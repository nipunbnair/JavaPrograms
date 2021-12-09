figure(1)
T=imread("C:\Users\nipun\OneDrive\Desktop\printout/p52.png");
imshow(T)
figure(2)
I = rgb2gray( T )
imshow(I)
figure(3)
Tgs=im2gray(T);
figure(4)
T1=imread("C:\Users\nipun\OneDrive\Desktop\printout/p51.png");
imshow(T1)
figure(5)
I1 = rgb2gray( T1 )
imshow(I1)
figure(6)
Tgs1=im2gray(T1);
if I == I1
    msgbox('Images are matched 100%!');
else
    msgbox('Images are NOT matched!');
    k=I-I1
    
end 

imshowpair(T,Tgs,"montage")
imhist(Tgs)
Tadj=imadjust(Tgs);
figure(4)
[L,centers]=imsegkmeans(T,5)
C=labeloverlay(T,L);
imshow(C)
title("image")