% learn the CSP projection matrix P from X
%             also added eigenvalue sorting to make things so that the first
%             projected channels are maximal in class 0 variance, and the last
%             projected channels are maximal in class 1 variance (or perhaps vice-versa)
%
% X -- data
% Y -- labels
%
function P = train_CSP(X, Y, baseclass)

% rename to common name for ease of use (and copying of code)
[dim1, dim2, dim3] = size(X);

% loop over the trials and form average covariance estimates for each class
% to hold accumulated covariance matrix for each condition
R_A = zeros(dim2);   % 0
R_B = zeros(dim2);   % 1
num_A = 0;
num_B = 0;
for i = 1 : dim1
    
    % compute the normalized covariance
    tmp = reshape(X(i, :, :), dim2, dim3);
    tmp = (tmp * tmp') / trace(tmp * tmp');
    
    % store into the proper average covariance
    % ***change below number to alter which class is compared to others***
    if(Y(i) == baseclass)
        R_A = R_A + tmp;
        num_A = num_A + 1;
    else
        R_B = R_B + tmp;
        num_B = num_B + 1;
    end
end

% divide the cumulative covariances by the number of examples
R_A = R_A / num_A;
R_B = R_B / num_B;

% form composite covariance
R_C = R_A + R_B;

% find the rank of R_C
rank_R_C = rank(R_C);

% do an eigenvector/eigenvalue decomposition
[V, D] = eig(R_C);

if(rank_R_C < dim2)
    disp(['pre_CSP_train: WARNING -- reduced rank data']);

    % keep only the non-zero eigenvalues and eigenvectors
    d = diag(D);
    d = d(end - rank_R_C + 1 : end);
    D = diag(d);

    V = V(:, end - rank_R_C + 1 : end);

    % create the whitening transform
    W = D^(-.5) * V';

else
    
    % create the whitening transform
    W = D^(-.5) * V';
    
end

% form the spatial patterns
S_A = W * R_A * W';
S_B = W * R_B * W';

% perform the eigendecomposition
[V_A, D_A] = eig(S_A);
[V_B, D_B] = eig(S_B);

% sort things so that the largest eigenvectors are first, and the smallest last
[val, ind] = sort(diag(D_A), 1, 'descend');
V_A = V_A(:, ind);
d_A = diag(D_A);
D_A = diag(d_A(ind));

V_B = V_B(:, ind);
d_B = diag(D_B);
D_B = diag(d_B(ind));

% form the projection matrix
P = V_A' * W;

% simply return P