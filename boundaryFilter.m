function imgfiltered = boundaryFilter(img, boundaries)
    % boundaries = [rowbound columnbound]
    
    [r, c] = size(img);
    brow = boundaries(1);
    bcol = boundaries(2);
    
    imgcore = ones(r-2*bcol, c-2*brow);
    filtermask = padarray(imgcore, [bcol brow], 'both');
    imgfiltered = img.*filtermask;
    
end