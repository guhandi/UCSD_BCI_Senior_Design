function feats= extract_feats2(rawdata, numchannels, fs, featdim, P,Fstop1,Fpass1,Fpass2,Fstop2)

feats=[];
Hdalpha= alphabut(Fstop1,Fpass1,Fpass2,Fstop2);
alphaband= filter(Hdalpha, rawdata);
cspfiltered=alphaband*P;
feats=transpose(log(bandpower(cspfiltered)));

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
