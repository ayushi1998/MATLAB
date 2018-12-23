classdef TriangleMesh
    
    properties
        
        vertices
        faces
        uv
        
        texture
        
        fvConnectivity
        
        number_of_vertices
        number_of_faces
        
    end
    
    methods
        
        % TriangleMesh(filename)
        % TriangleMesh(vertices, faces)
        function obj = TriangleMesh(varargin)
            obj.uv = [];
            obj.texture = [];
            if nargin == 1
                filename = varargin{1};
                if sum(filename(end-2:end) == 'off') == 3
                    [obj.vertices, obj.faces] = obj.parse_off(filename);
                end
            elseif nargin == 2
                obj.vertices = varargin{1};
                obj.faces = varargin{2};
            end                
            obj.number_of_vertices = size(obj.vertices, 1);
            obj.number_of_faces = size(obj.faces, 1);
            obj.fvConnectivity = obj.calculatefvConnectivity();
        end
        
        function export_obj(obj, filename)
            fid = fopen(filename, 'w');
            
            if ~isempty(obj.texture)
                fid2 = fopen('material.mtl', 'w');
                fprintf(fid2, 'newmtl mat\n');
                fprintf(fid2, 'Ka 1.000000 1.000000 1.000000\n');
                fprintf(fid2, 'Kd 1.000000 1.000000 1.000000\n');
                fprintf(fid2, 'Ks 0.000 0.000 0.000\n');
                fprintf(fid2, 'map_Ka %s\n', obj.texture);
                fprintf(fid2, 'map_Kd %s\n', obj.texture);
                fclose(fid2);
                
                fprintf(fid, 'mtllib material.mtl\n');
                fprintf(fid, 'usemtl mat\n');
            end
            
            fprintf(fid, 'v %f %f %f\n', obj.vertices.');
            if isempty(obj.uv)
                fprintf(fid, 'f %d %d %d\n', obj.faces.');
            else
                fprintf(fid, 'vt %f %f\n', obj.uv.');
                fs = obj.faces.';
                fs = fs(:);
                fs = kron(fs, [1;1]);
                fprintf(fid, 'f %d/%d %d/%d %d/%d\n', fs);
            end
            
            fclose(fid);
        end
        
        
        function [v, f] = parse_off(obj, filename)
            fid = fopen(filename,'r');

            % Check for the OFF magic str
            s = fgets(fid);
            if ~strcmp(s(1:3), 'OFF')
                warning('The file is not in OFF format');
                v = [];
                f = [];
                return;
            end

            % Skip empty lines and comments
            s = fgets(fid);
            while isempty(s) || s(1) == '#' || s(1) == ' '
                s = fgets(fid);
            end

            [n, s] = strtok(s);
            num_of_verts = str2num(n);
            [n, s] = strtok(s);
            num_of_faces = str2num(n);

            v = reshape(fscanf(fid, '%f', 3 * num_of_verts), 3, num_of_verts)';

            f = reshape(fscanf(fid, '%d', 4 * num_of_faces), 4, num_of_faces);
            f = f(2:4, :)' + 1;

        end
                
        function fvConnectivity = calculatefvConnectivity(obj)
            fvConnectivity = sparse(repmat(1:obj.number_of_faces, 1, 3), ...
                           obj.faces, ...
                           ones(size(obj.faces)), ...
                           obj.number_of_faces, obj.number_of_vertices);
        end
    end
end
