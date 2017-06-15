function bimgf = radialFilter(bimg, center, radii, sectorangles)
    % Filter points in between the inner and outer radii
    % in a binarized image
    
    bimgf = bimg;
    
    % Assign the inner and outer radii of filter ring
    inrad = min(radii);
    outrad = max(radii);
    
    % Assign the lower and upper angular bounds of the blocking sector
    lbang = min(sectorangles);
    ubang = max(sectorangles);
    
    % Calculate the distance of nonzero points wrt to center
    [rnz, cnz] = find(bimg > 0);
    dist = round(sqrt((rnz - center.y).^2 + (cnz - center.x).^2));
    %angles = atand((rnz - center.y)./(cnz - center.x));
    
    % Set the points lying in the ring to zero
    for i = 1:numel(dist)
        angle = atandrescale(center.y - rnz(i), cnz(i) - center.x);
        filtercondition = dist(i) >= inrad && dist(i) <= outrad && (angle < lbang || angle > ubang);
        if  filtercondition
            bimgf(rnz(i), cnz(i)) = 0;
        end
    end
    
    function v = atandrescale(y,x)
        
        v = nan;
        % First & second quadrants
        if y>0
            v = atan2(y,x);
        end
        % Third & fourth quadrants
        if y<0
            v = 2*pi + atan2(y,x);
        end

        v = v*180/pi;

    end
    
end