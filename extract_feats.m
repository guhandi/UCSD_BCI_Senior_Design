function feats= extract_feats(rawdata,P,Fstop1,Fpass1,Fpass2,Fstop2)

feats=[];
Hdalpha= alphabut(Fstop1,Fpass1,Fpass2,Fstop2);
alphaband= filter(Hdalpha, rawdata);
cspfiltered=alphaband*P;
feats=transpose(log(bandpower(cspfiltered)));
a=bandpower(alphaband(:,1:22));
feats= [feats; log(transpose(a))];
end