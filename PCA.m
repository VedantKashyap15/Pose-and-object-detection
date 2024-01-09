
function [alpha,beta]=PCA(train_images,test_images,train_subj,test_subj,k_val,train_angles,test_angles)
    N_train=size(train_images,2); %(No. of images in training dataset=192)
    N_test=size(test_images,2);   %(No. of images in test dataset=128)
    
    %Taking the mean of all x_i's
    x_bar=mean(train_images,2);
    %Mean deduction for training images
    X=train_images-x_bar;
    %Mean deduction for test images
    Y=test_images-x_bar;
    L_mat=transpose(X)*X;
    
    %PCA
    
    %eigs
    %Calculate eigenvalues of L
    [V,D]=eig(L_mat);
    %Sort eigenvalues of L
    
    [d,idx]=sort(diag(D),'descend');
    %Re-order eigenvectors
    D_sorted=D(idx,idx);
    V_sorted=V(:,idx);
    
    %Obtain eigenvectors of C
    U=X*V_sorted;
    U=normalize(U,"norm");
    count=0;
    obj=0;
    pose1=0;
    pose2=0;
    thres=100;
    k_eigen_space=U(:,1:k_val);
    train_eigen_coeff=transpose(k_eigen_space)*X;
    test_eigen_coeff=transpose(k_eigen_space)*Y;
    
    % eigen_space_25 = U(:, 1:25);
    % 
    % for i = 1:25
    %     eigen_vec = reshape(eigen_space_25(:, i), 128, 128      );
    %     subplot(5, 5, i); imagesc(eigen_vec); colormap("gray");
    % end
    alpha=train_eigen_coeff;
    beta=test_eigen_coeff;
    
end