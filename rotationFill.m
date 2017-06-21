function bimg_filled = rotationFill(bimg, rotangle, threshold)
    % bimg: binarized image
    % rotangle: rotation angle (in degrees)
    
    % Find the coordinates of the nonzero entries in a binarized image 
    [rnz, cnz] = find(bimg > 0);
    
    if rotangle == 0
        % line fill image along row direction
        bimg_filled = axisFill(bimg, rnz, cnz, 1, threshold);
    elseif rotangle == 90
        % line fill image along column direction
        bimg_filled = axisFill(bimg, cnz, rnz, 2, threshold);
    else
        coords = [rnz, cnz];
        for i = 1:length(rnz)
            iangle = round(atand((rnz(i) - rnz)./(cnz(i) - cnz)));
            cind = find(iangle == rotangle);
            % If the pixels exist that satisfy the angular separation,
            % fill the line in between (the two with maximal expanse)
            if cind
                disp(size(cind))
                bimg_filled = bimg + lineFill(bimg, coords(i,:), coords(cind',:));
            end
        end
        bimg_filled = logical(bimg_filled);
    end
    
    function imgaxfill = axisFill(bimg, linecoord, fillcoord, indflag, distthreshold)
        % Group along the line coordinates. Fill the intervening points along each line.
        
        % l_id: line index
        % uni_l: unique line number
        [l_id, uni_l] = findgroups(linecoord);
        imgaxfill = bimg;
        
        for j = 1:length(uni_l) % Loop over distinct groups
            
            % Locate the indices of elements that are grouped together
            inds = find(l_id == j);
            fillarray = fillcoord(inds);
            dist = abs(fillarray - 300);
            fillarray = fillarray(dist < distthreshold);
            
            % Fill line the with at least two values
            if numel(fillarray) >= 2
            
                if indflag == 1
                    imgaxfill(uni_l(j), min(fillarray):max(fillarray)) = 1;
                elseif indflag == 2
                    imgaxfill(min(fillarray):max(fillarray), uni_l(j)) = 1;
                end
            
            end
            
        end
        
    end

    function imglinefill = lineFill(bimg, fillstart, fillend)
        % Fill the interpolated line of pixels between the start (fillstart)
        % and end points (fillend). The number of starting points needs to
        % be 1, but that of the ending points can be larger than 1.
        
        imglinefill = bimg;
        for np = 1:size(fillend)/2
            rval = [fillstart(1), fillend(np,1)];
            cval = [fillstart(2), fillend(np,2)];
            rinterm = fillstart(1):fillend(1);
            cinterm = interp1(rval, cval, rinterm);
            fill_ind = round(sub2ind(size(bimg), rinterm, cinterm));
            imglinefill(fill_ind) = 1;
        end
        
    end
    
end
    
    