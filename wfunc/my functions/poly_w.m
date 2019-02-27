%this functiton is used to get the outline of the polygon maken of the points you have choosen 

function [lx,ly]=poly_w(newX,newY)
lx=[];
ly=[];
newX=[newX;newX(1)];
newY=[newY;newY(1)];

for i=1:length(newX)-1
    if abs(newX(i+1)-newX(i))>=abs(newY(i+1)-newY(i))  %avoid gaps
        if newX(i+1)>=newX(i)             
            LX{i}=newX(i):newX(i+1);
        else                               %reverse order
            LX{i}=[newX(i):-1:newX(i+1)];
        end
        LY{i}=ceil((LX{i}-newX(i))*(newY(i+1)-newY(i))/(newX(i+1)-newX(i))+newY(i));    
        
    else
        if newY(i+1)>=newY(i)             
            LY{i}=newY(i):newY(i+1);
        else                               
            LY{i}=[newY(i):-1:newY(i+1)];
        end
        LX{i}=ceil((LY{i}-newY(i))*(newX(i+1)-newX(i))/(newY(i+1)-newY(i))+newX(i));  
    end
    
    lx=ceil([lx,LX{i}]);
    ly=ceil([ly,LY{i}]);
end
