#!/usr/bin/gawk -f
@load "readdir"
@load "filefuncs"

function fix(){
	pwd=ENVIRON["PWD"]
	fs=FS
	FS="/"
	while((getline<pwd)>0){
		if($3=="d"&&$2!~/^\.+$/){conts[$2]=$2}
	}
	for(i in conts){
		contsiz=pwd"/"conts[i]
		while((getline<contsiz)>0){
			if($3=="d"&&$2!~/^\.+$/){
				while((getline<contsiz)>0){
					contsizic=contsiz"/"$2
					if($3=="d"&&$2!~/^\.+$/){while((getline<contsizic)>0){
						if($3~"l"){
							flink=contsizic"/"$2
							stat(flink, statdata)
							if(statdata["linkval"]~/^\.\/[a-zA-Z]/){
								newtarget=statdata["linkval"]
								gsub(/^\.\//,"",newtarget)
								cmd="ln -sf " newtarget " " flink
								#system(cmd)
								#close(cmd)
								print flink, $3, statdata["linkval"]
							}
						}
					}}
				}
			}
		}
	}
	FS=fs
}

BEGIN{
fix()
}
