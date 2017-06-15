function p_edge = findPersistentEdge(img, thresholds)
    % Determine the persistent low-intensity edge in an image
    
    % Allocate space for the edge matrix
    p_edge = ones(size(img));

    for i = 1:length(thresholds)
       imgtmp = img;
       % Threshold the whole image
       imgtmp(imgtmp > thresholds(i)) = 0;
       % Locate the persistent edge at different thresholds
       %p_edge = p_edge.*edge(imgtmp,'Canny',0.1,0.5);
       %p_edge = p_edge.*edge(imgtmp, 'Sobel', 3, 'both');
       p_edge = p_edge.*(edge(imgtmp, 'Sobel', 3, 'both', 'nothinning').*edge(imgtmp,'Canny',0.02,0.6));
    end

end