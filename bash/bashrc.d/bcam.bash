vlc_cmd="vlc --no-audio"                                                                                                                                                                      
cam_queue="rtsp://10.31.27.11:554//Streaming/Channels/1"                                                                                                                                      
cam_packing="rtsp://10.31.27.12:554//Streaming/Channels/1"                                                                                                                                    
bcam() {                                                                                                                                                                                      
  $vlc_cmd $cam_queue & $vlc_cmd $cam_packing &                                                                                                                                               
}  

