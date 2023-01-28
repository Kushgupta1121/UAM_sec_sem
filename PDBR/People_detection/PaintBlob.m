function imagen=PaintBlob(blob,imagen,color)

alto=size(imagen,1);
ancho=size(imagen,2);



for i=1:blob.w
    for j=1:blob.h
        if(j+blob.y>=1 && j+blob.y<=alto)
            if(i+blob.x>=1 && i+blob.x<=ancho)
                if(j<=2)%upper line
                    imagen(j+blob.y,i+blob.x,:)=color;
                end
                if(j==blob.h || j==blob.h-1)%bottom line
                    imagen(j+blob.y,i+blob.x,:)=color;
                end
                if(i<=2)%left line
                    imagen(j+blob.y,i+blob.x,:)=color;
                end
                if(i==blob.w || i==blob.w-1)%right line
                    imagen(j+blob.y,i+blob.x,:)=color;
                end
            end
        end
    end
end
%%paint center
center_x=floor(blob.x+blob.w/2);
center_y=floor(blob.y+blob.h/2);
% imagen(center_y,center_x,:)=color;
