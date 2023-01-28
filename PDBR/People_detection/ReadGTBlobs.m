function [Blobs Scores]=ReadTUDBlobsaux(filename,video_name,processing_mask)


if nargin < 3
    processing_mask.x=0;
    processing_mask.y=0;
    processing_mask.w=inf;
    processing_mask.h=inf;
end

fid=fopen(filename);
cadena=fgets(fid);
num_frame=1;
Blobs={};
Blobs{num_frame}=[];
Scores=[];
while( size(cadena,2)>4 )
    inicios=find(cadena=='(');
    separadores=find(cadena=='/');
    puntos=find(cadena==':');
    num_blobs=size(inicios,2);
   
    if(num_blobs>0)
        aux=sprintf('"./%s-%%d.png":',video_name);
        num_frame=sscanf(cadena(1,1:puntos(1)),aux);
        Temp=sscanf(cadena(1,inicios(1):end),'(%d, %d, %d, %d):%f, ');
        Blobs{num_frame}=[];
        for i=1:num_blobs
            auxX1=Temp((i-1)*5+1);
            auxY1=Temp((i-1)*5+2);
            auxX2=Temp((i-1)*5+3);
            auxY2=Temp((i-1)*5+4);
            Score=Temp((i-1)*5+5);
            
            if(auxX1<auxX2)
                X1=auxX1;
                X2=auxX2;
            else
                X1=auxX2;
                X2=auxX1;
            end
            if(auxY1<auxY2)
                Y1=auxY1;
                Y2=auxY2;
            else
                Y1=auxY2;
                Y2=auxY1;
            end
            
            if X1<0
                blob.x=0;
            else
                blob.x=X1;
            end
            if Y1<0
                blob.y=0;
            else
                blob.y=Y1;
            end
            blob.w=abs(X1-X2);
            blob.h=abs(Y1-Y2);
            blob.num_frame=num_frame;
            blob.score=Score;            

            
                %%remove blobs outside the process mask
                center.x=blob.x+blob.w/2;
                center.y=blob.y+blob.h/2;
                if(center.x>processing_mask.x && center.x<processing_mask.x+processing_mask.w)
                    if(center.y>processing_mask.y && center.y<processing_mask.y+processing_mask.h)
                        Blobs{num_frame}=[Blobs{num_frame} blob];
                        Scores=[Scores blob.score];
                    end
                end
        end
    end
    
    
    cadena=fgets(fid);
    
end

fclose(fid);
