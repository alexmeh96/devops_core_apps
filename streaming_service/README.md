в дирректорию audio/video вместо текстоого файла положить test.mp3/test.mp4 файл и выполнить конвертацию для HLS 

### Конвертация видео для HLS

Пример конвертации файлов test.mp3/test.mp4 в файлы test.m3u8 и в список фалов output_*.ts:

FullHD
```shell
ffmpeg -i video/test.mp4 \
-c:v libx264 -profile:v main -level 4.2 \
-s 1920x1080 -b:v 5000k \
-c:a aac -b:a 192k \
-hls_time 10 -hls_list_size 0 \
-hls_segment_filename "video/hls/output_%03d.ts" video/hls/test.m3u8
```
HD
```shell
ffmpeg -i video/test.mp4 \
-c:v libx264 -profile:v main -level 4.0 \
-s 1280x720 -b:v 2000k \
-c:a aac -b:a 128k \
-hls_time 10 -hls_list_size 0 \
-hls_segment_filename "video/hls/output_%03d.ts" video/hls/test.m3u8
```
360p
```shell
ffmpeg -i video/test.mp4 \
-c:v libx264 -profile:v main -level 3.1 \
-s 640x360 -b:v 800k \
-c:a aac -b:a 128k \
-ar 44100 -f hls \
-hls_time 10 -hls_list_size 0 \
-hls_segment_filename "video/hls/output_%03d.ts" video/hls/test.m3u8
```
### Конвертация аудио для HLS
```shell
ffmpeg -i audio/test.mp3 -c:a aac -b:a 128k -f segment -segment_time 10 -segment_list audio/hls/test.m3u8 -segment_format mpegts "audio/hls/output_%03d.ts"
```
