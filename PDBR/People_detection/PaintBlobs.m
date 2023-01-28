function imagen=PaintBlobs(blobs,imagen,color)

for i=1:size(blobs,2)
    blob=blobs(i);
    imagen=PaintBlob(blob,imagen,color);
end
