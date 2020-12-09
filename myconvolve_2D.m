
function g=myconvolve_2D(image,w,pad)

% for greyscale image
if size(image,3)==1

L1=size(image);
B=zeros(L1(1),L1(2));
ima=im2double(image);
A=zeros(L1(1)+2,L1(2)+2);
L=size(A);

% for different types of padding based on input parameter
switch pad
    
    case 1
        A(2:L(1)-1,2:L(2)-1)=ima;
        

    case 2
         A(2:L(1)-1,2:L(2)-1)=ima;
         A(1,2:L(2)-1)=ima(1,:);
         A(L(1),2:L(2)-1)=ima(L1(1),:);
         A(2:L(1)-1,1)=ima(:,1);
         A(2:L(1)-1,L(2))=ima(:,L1(2));
         A(1,L(2))=ima(1,L1(2));
         A(L(1),L(2))=ima(L1(1),L1(2));
         A(L(1),1)=ima(L1(1),1);
         A(1,1)=ima(1,1);
         
   
    case 3
         A(2:L(1)-1,2:L(2)-1)=ima;
         A(1,2:L(2)-1)=ima(1,:);
         A(L(1),2:L(2)-1)=ima(L1(1),:);
         A(2:L(1)-1,1)=ima(:,1);
         A(2:L(1)-1,L(2))=ima(:,L1(2));
         A(1,L(2))=ima(1,L1(2));
         A(L(1),L(2))=ima(L1(1),L1(2));
         A(L(1),1)=ima(L1(1),1);
         A(1,1)=ima(1,1);
         
    
    case 4
         A(2:L(1)-1,2:L(2)-1)=ima;
         A(1,2:L(2)-1)=ima(L1(1),:);
         A(L(1),2:L(2)-1)=ima(1,:);
         A(2:L(1)-1,1)=ima(:,L1(2));
         A(2:L(1)-1,L(2))=ima(:,1);
         A(1,L(2))=ima(L1(1),1);
         A(L(1),L(2))=ima(1,1);
         A(L(1),1)=ima(1,L1(2));
         A(1,1)=ima(L1(1),L1(2));
         
end
        


for i=2:L(1)-1
    for j=2:L(2)-1
        sum=(A(i-1,j-1)*w(1,1))+(A(i-1,j)*w(1,2))+(A(i-1,j+1)*w(1,3))+(A(i,j-1)*w(2,1))+(A(i,j)*w(2,2))+(A(i,j+1)*w(2,3))+(A(i+1,j-1)*w(3,1))+(A(i+1,j)*w(3,2))+(A(i+1,j+1)*w(3,3));
        B(i-1,j-1)=sum;
    end
end
g=B;

%for RGB image
else
    
L1=size(image);
B=zeros(L1(1),L1(2),3);
ima=im2double(image);
A=zeros(L1(1)+2,L1(2)+2,3);
L=size(A);

% for different tyoes of padding based on input parameter
switch pad
    
    case 1
        A(2:L(1)-1,2:L(2)-1,:)=ima;
        

    case 2
         A(2:L(1)-1,2:L(2)-1,:)=ima;
         A(1,2:L(2)-1,:)=ima(1,:,:);
         A(L(1),2:L(2)-1,:)=ima(L1(1),:,:);
         A(2:L(1)-1,1,:)=ima(:,1,:);
         A(2:L(1)-1,L(2),:)=ima(:,L1(2),:);
         A(1,L(2),:)=ima(1,L1(2),:);
         A(L(1),L(2),:)=ima(L1(1),L1(2),:);
         A(L(1),1,:)=ima(L1(1),1,:);
         A(1,1,:)=ima(1,1,:);
         
   
    case 3
         A(2:L(1)-1,2:L(2)-1,:)=ima;
         A(1,2:L(2)-1,:)=ima(1,:);
         A(L(1),2:L(2)-1,:)=ima(L1(1),:,:);
         A(2:L(1)-1,1,:)=ima(:,1,:);
         A(2:L(1)-1,L(2),:)=ima(:,L1(2),:);
         A(1,L(2),:)=ima(1,L1(2),:);
         A(L(1),L(2),:)=ima(L1(1),L1(2),:);
         A(L(1),1,:)=ima(L1(1),1,:);
         A(1,1,:)=ima(1,1,:);
         
    
    case 4
         A(2:L(1)-1,2:L(2)-1,:)=ima;
         A(1,2:L(2)-1,:)=ima(L1(1),:,:);
         A(L(1),2:L(2)-1,:)=ima(1,:,:);
         A(2:L(1)-1,1,:)=ima(:,L1(2),:);
         A(2:L(1)-1,L(2),:)=ima(:,1,:);
         A(1,L(2),:)=ima(L1(1),1,:);
         A(L(1),L(2),:)=ima(1,1,:);
         A(L(1),1,:)=ima(1,L1(2),:);
         A(1,1,:)=ima(L1(1),L1(2),:);
         
end
        
for k=1:3
    for i=2:L(1)-1
        for j=2:L(2)-1
        sum=(A(i-1,j-1,k)*w(1,1))+(A(i-1,j,k)*w(1,2))+(A(i-1,j+1,k)*w(1,3))+(A(i,j-1,k)*w(2,1))+(A(i,j,k)*w(2,2))+(A(i,j+1,k)*w(2,3))+(A(i+1,j-1,k)*w(3,1))+(A(i+1,j,k)*w(3,2))+(A(i+1,j+1,k)*w(3,3));
        B(i-1,j-1,k)=sum;
        end
    end
end
g=B;
end
    
end


