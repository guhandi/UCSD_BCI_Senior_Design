function feats= extract_feats2(rawdata, numchannels, fs, featdim, P1,P2,P3,Fstop1,Fpass1,Fpass2,Fstop2)

feats=[];
Hdalpha= alphabut(Fstop1,Fpass1,Fpass2,Fstop2);
alphaband= filter(Hdalpha, rawdata);
cspfiltered=alphaband*P1;
feats=transpose(log(bandpower(cspfiltered)));
cspfilt2=alphaband*P2;
cspfilt3=alphaband*P3;
feats=[feats; log(transpose(bandpower(cspfilt2)))];
feats=[feats; log(transpose(bandpower(cspfilt3)))];

%}
%{
for i=1:numchannels
  
    [thr,sorh,keepapp] = ddencmp('den','wv',rawdata(:,i));
    xd = wdencmp('gbl',rawdata(:,i),'dmey',2,thr,sorh,keepapp);
    %{
    figure
    plot(rawdata(:,i))
    figure
    plot(xd)
    pause
    %}
    
    alphaband= filter(Hdalpha, xd);
    a=bandpower(alphaband);
    feats=[feats; log(a)];
end
%}


%a=bandpower(alphaband(:,1:22));
%feats= [feats; log(transpose(a))];
%disp(length(feats))

end
