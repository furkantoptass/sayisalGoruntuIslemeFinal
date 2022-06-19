	
v = VideoWriter('newfile'); % Oluşturulan Figure'nin kaydedilmesi için VideoWriter kütüphanesini kullanıyoruz. 
vidObj = VideoReader('C:\Users\topta\Desktop\matlab_odev\para.mp4'); % Video oluşturulması için VideoReader kütüphanesini kullanıyoruz.
open(v)

while hasFrame(vidObj)

    imageorj = readFrame(vidObj);	  
	  image=rgb2gray(imageorj);
      level=graythresh(image);
	  bw=im2bw(image,level);
	  % figure(2),imshow(bw);
	  
	  bw=imcomplement(bw); % Resmi negatiflik ekliyoruz.
	  % figure(3),imshow(bw)
	  bw=imfill(bw,'holes');    % Resimde çukur diye nitelendirilen yerleri dolduruyoruz.
	  bw = bwareaopen(bw,30);	% 30px den daha az sayıda olan nesneler kaldırılıyor. 
	  % figure(4),imshow(bw);
	  
	  se=strel('disk',11); %Yarıçapı 11px olan disk biçiminde yapısal element oluşturuyoruz.
	  bw2=imerode(bw,se); %Birlesik madeni paralarin ayrilmasi saglaniyor.
	  % figure(5),imshow(bw2);
	  
	  [B,L] = bwboundaries(bw2);  
   % length(B) ile para adetini ogrendik ve etiket 
   stats = regionprops(bw2, 'Area','Centroid');
   A=figure(6),
   imshow(imageorj);    
   toplam = 0;    
   for n=1:length(B)        
   a=stats(n).Area;  % Her paranın alanını öğrendik. Boyutlara göre hesaplama yaptık.
   centroid=stats(n).Centroid;            
   if a> 1700 && a<4000 %1200 
   toplam = toplam + 1; text(centroid(1),centroid(2),'1TL'); 
   
   elseif a >1100 &&  a < 1700% elseif a >800 &&  a < 1050  
   toplam = toplam + 0.5;  
   text(centroid(1),centroid(2),'50Kr');   
   elseif a >700 &&  a < 1100                
   toplam = toplam + 0.25;               
   text(centroid(1),centroid(2),'25Kr');        
   elseif a > 600 &&  a < 700                
   toplam = toplam + 0.10;                
   text(centroid(1),centroid(2),'10Kr');         
   elseif a>50 && a<600                 
   toplam = toplam + 0.05;        
   text(centroid(1),centroid(2),'5Kr');
   else 
   toplam = toplam      
   end    
   end     
   title(['Toplam para miktari = ',num2str(toplam),' TL']) % Toplam para miktarını ekrana yazdık.
   pause(1/vidObj.FrameRate); %Video frameri sayısına göre bekleme yapıyoruz.
	frameR = getframe(gcf); % Figure'i getframe kutuphanesi ile kaydediyoruz.
	writeVideo(v,frameR) % Video oluşturulması için writeVideo kütüphanesini kullanıyoruz.
	
end
close(v)