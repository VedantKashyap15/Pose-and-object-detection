%% MyMainScript
%% Your code here
%% This is the implementation of HW4-Q1 for the ORL database
tic;
clear;
clc;
dirname="C:\Users\Soham Inamdar\OneDrive - Indian Institute of Technology Bombay\Soham\IIT_Bombay\Academics\Sem-5\CS663\Project\coil-20-proc\coil-20-proc\obj";
%First we load the train and test data
train_images=[];  %Training Images
train_angles=[];
train_subj=[];    %Training Objects
test_images=[];   %Test Images
test_subj=[];  %Test Objects
test_angles=[];
%Reading the training and testing data
for i = 1:20
   
    for j = 0:71
         currentfilename = dirname + num2str(i) + "__"+num2str(j)+".png";
         currentimage = im2double(imread(currentfilename));
         %imshow(currentimage);
         
        
        if (mod(j,6)==1)
            test_images = cat(2, test_images, currentimage(:));
            test_subj = cat(2, test_subj, i);
            test_angles=cat(2,test_angles,j);

        else
            train_images = cat(2, train_images, currentimage(:));
            train_subj = cat(2, train_subj, i);
            train_angles=cat(2,train_angles,j);
        end
    end
    
end
count1=0;
count2=0;
obj=0;
pose1=0;
pose2=0;
[alpha,beta]=PCA(train_images,test_images,train_subj,test_subj,20,train_angles,test_angles);
N_train=size(train_images,2); %(No. of images in training dataset=192)
N_test=size(test_images,2);   %(No. of images in test dataset=128)
arr1=[];
for i=1:N_test
        arr_mse=sum((alpha - beta(:, i)).^2);
        [minval,ind]=min(arr_mse);
        
        if (train_subj(ind)==test_subj(i))
           obj=train_subj(ind);
           % count1=count1+1;
           % pose1=train_angles(ind);
           % disp(pose1);
           % disp(obj);
           % if (abs(pose1-test_angles(i))<2)
           %     count2=count2+1;
           % end
           train_images1=train_images(:,60*(obj-1)+1:60*obj);
           train_subj1=train_subj(60*(obj-1)+1:60*obj);
           test_subj1=test_subj(12*(obj-1)+1:12*obj);
           test_images1=test_images(:,12*(obj-1)+1:12*obj);
           train_angles1=train_angles(60*(obj-1)+1:60*obj);
           test_angles1=test_angles(12*(obj-1)+1:12*obj);
           n1=size(test_images1,2);
           [alpha1,beta1]=PCA(train_images1,test_images1,train_subj1,test_subj1,10,train_angles1,test_angles1);
           

           f=spline(train_angles1,alpha1);
           y1=[];
           x1=[];
           count=0;
           for k = 1:size(beta1,2)
               min_err=Inf;
               angle=-1;
               for l=0:71
                   y=ppval(f,l);
                   mse=norm(y-beta1(:,k));
                   if (mse<min_err)
                       min_err=mse;
                       angle=l;

                   end
               end

               if (abs(angle-test_angles1(k))<1)
                   count=count+1;
                   count2=count2+1;
               end
           end
           arr1=cat(1,arr1,count/12);
           
            

           % for j=1:n1
           %     arr_mse_pose=sum((alpha1 - beta1(:, j)).^2);
           %     [minval1,ind1]=min(arr_mse_pose);
           %     arr_mse_pose2=arr_mse_pose(arr_mse_pose~=minval1);
           %     [minval2,ind2]=min(arr_mse_pose2);
           %     pose1=train_angles1(ind1);
           %     disp(pose1);
           %     disp(obj);
           %     if (abs(pose1-test_angles1(j))<2)
           %         count2=count2+1;
           %     end
           % end
        end      
end
disp(count2/(N_test*n1));
plot(arr1);
% disp(obj);
% disp(pose);











