classdef class_mesh
    properties
        noNodes
        elements
        noElements
        boundaryFaces
        internalFaces
        noBoundaryFaces
        noInternalFaces
        noFaces
    end
    methods
        function obj = constructor(obj, triangulation)
            % Construct elements.
            obj.noNodes    = length(triangulation.Points);
            obj.noElements = length(triangulation.ConnectivityList);
            neighbours     = neighbors(triangulation);
            for i = 1:obj.noElements
                obj.elements{i}                 = class_element;
                obj.elements{i}.elementNo       = i;
                points = triangulation.Points(triangulation.ConnectivityList(i, :), :);
                obj.elements{i}.nodeCoordinates = points;
                obj.elements{i}.neighbours      = neighbours(i, :);
            end
            
            % Construct faces.
            e = sort(edges(triangulation), 2);
            b = sort(freeBoundary(triangulation), 2);
            n = setdiff(e, b, 'rows');
            
            obj.noFaces         = length(e);
            obj.noBoundaryFaces = length(b);
            obj.noInternalFaces = length(n);
            for i = 1:obj.noBoundaryFaces
                obj.boundaryFaces{i}                 = class_face;
                obj.boundaryFaces{i}.faceNo          = i;
                points = triangulation.Points(b(i, :), :);
                obj.boundaryFaces{i}.nodeCoordinates = points;
                neighbours = edgeAttachments(triangulation, b(i, 1), b(i, 2));
                obj.boundaryFaces{i}.neighbours      = neighbours{:};
            end
            for i = 1:obj.noInternalFaces
                obj.internalFaces{i}                 = class_face;
                obj.internalFaces{i}.faceNo          = i+obj.noBoundaryFaces;
                points = triangulation.Points(n(i, :), :);
                obj.internalFaces{i}.nodeCoordinates = points;
                neighbours = edgeAttachments(triangulation, n(i, 1), n(i, 2));
                obj.internalFaces{i}.neighbours      = neighbours{:};
            end
        end
    end
end