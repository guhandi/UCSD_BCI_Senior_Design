function [combined, combinedlabels]= get_data_A0xT(noclass, windowsize, startsample,x)
if x==1
    load 'A01T.mat'
end
if x==2
    load 'A02T.mat'
end
if x==3
    load 'A03T.mat'
end
if x==4
    load 'A05T.mat'
end
if x==5
    load 'A06T.mat'
end


combined=[];
combinedlabels=[];

for i=4:9
    for j=1:48
        if ~data{1,i}.artifacts(j) && data{1,i}.y(j)~=noclass
            combined=[combined; data{1,i}.X((data{1,i}.trial(j)+startsample):(data{1,i}.trial(j)+startsample+windowsize-1),1:22)];
            combinedlabels=[combinedlabels data{1,i}.y(j)*ones(1,windowsize)];
            %combinedlabels=[combinedlabels data{1,i}.y(j)];
        end
    end
end
     