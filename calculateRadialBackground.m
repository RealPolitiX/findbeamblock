function [polquantile, radialBackground] = calculateRadialBackground(img, center, q, mask, nlim)
    % Returns radial quantiles (polquantile) picked in input argument and
    % reconstructed radial background to be subtracted from the original image
    
    % Apply mask to the image
    imgmasked = (1-mask).*img;
    
    % Turn intensity matrix into coordinate-intensity matrix
    [r, c] = size(img);
    cartcoordmat = zeros(r*c, 3);
    for i = 1:r*c % Loop over the total number of pixels
        [suby, subx] = ind2sub([r,c], i);
        % Subtract beam center position
        cartcoordmat(i,1) = subx - center.x;
        cartcoordmat(i,2) = center.y - suby;
        cartcoordmat(i,3) = imgmasked(i);
    end
    
    % Remove those with value = 0 (masked pixels)
    cartcoordmat(cartcoordmat(:,3) == 0, 3) = NaN;
    polcoordmat = cartcoordmat;
    
    % Transform from Cartesian to polar coordinate
    % r = sqrt(x^2 + y^2)
    % theta = arctan(y/x) (in radian)
    polcoordmat(:,1) = round(sqrt(cartcoordmat(:,1).^2 + cartcoordmat(:,2).^2));
    polcoordmat(:,2) = atan2(cartcoordmat(:,2), cartcoordmat(:,1));
    
    % Calculate quantile at each unique radial position (in polar coordinate)
    unir = unique(polcoordmat(:,1));
    nunir = numel(unir);
    polquantile = zeros(nunir,2);
    polquantile(:,1) = unir;
    for j = 1:nunir % Loop over the unique r positions
        rcoord = find(polcoordmat(:,1) == unir(j));
        % Calculate the quantile without NaN entries
        rquantile = quantileNaN(polcoordmat(rcoord,3), q);
        polquantile(j,2) = rquantile;
    end
    
    % Smooth the radial quantile (remove outliers by looking at neighbors)
    % in the non-masked region of the image
    % Marker value (mval)
    nznum = find(polquantile(:,2)~=0);
    [maxq, maxind] = max(polquantile(:,2));
    mval = maxq/exp(1);
    inds = find(polquantile(maxind:end,2) < mval);
    polquantile(nznum(1):inds(1),2) = medfilt1(polquantile(nznum(1):inds(1),2), 7);
    polquantile(inds(1):end,2) = medfilt1(polquantile(inds(1):end,2), 23);

    % Construct radial quantile background
    radialBackground = img;
    for k = 1:r*c
        [suby, subx] = ind2sub([r,c], k);
        dist = round(sqrt((subx - center.x)^2 + (center.y - suby)^2));
        % Compare the radial quantile look-up table (polquantile)
        radialBackground(k) = polquantile(polquantile(:,1) == dist, 2);
        %disp(radialBackground(k))
    end
    
    % Apply mask to the calculated radial background
    radialBackground = (1-mask).*radialBackground;
    
    function qt = quantileNaN(arr, q)
        % Calculate the quantile of an array (arr) excluding the NaN values
        
        arrNaN = arr(~isnan(arr));
        if arrNaN
            qt = quantile(arrNaN, q);
        else
            qt = 0;
        end
        
    end

end