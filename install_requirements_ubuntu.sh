#!/usr/bin/env sh

### 201805 Script written and fully commented by James Shane ( github.com/jamesshane )

#refrsh apt
sudo apt update

#adobe-source-code-pro-fonts **
#added binutils,gcc,make,pkg-config,fakeroot for compilations, removed yaourt
sudo apt install git nitrogen rofi python-pip binutils gcc make pkg-config fakeroot cmake python-xcbgen xcb-proto libxcb-ewmh-dev wireless-tools -y

#sudo apt-get install libxcb-randr0-dev libxcb-xtest0-dev libxcb-xinerama0-dev libxcb-shape0-dev libxcb-xkb-dev -y 

#added PYTHONDONTWRITEBYTECODE to prevent __pycache__
export PYTHONDONTWRITEBYTECODE=1
sudo -H pip install -r requirements.txt

[ -d /usr/share/fonts/opentype ] || sudo mkdir /usr/share/fonts/opentype
sudo git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp
sudo fc-cache -f -v

wget http://mirrors.kernel.org/ubuntu/pool/main/f/fonts-font-awesome/fonts-font-awesome_4.7.0~dfsg-3_all.deb
sudo apt install -f ./fonts-font-awesome_4.7.0~dfsg-3_all.deb

git clone https://github.com/jaagr/polybar
cd polybar
./build.sh -f
cd build
sudo make install
make userconfig
cd ../..

#file didn't exist for me, so test and touch
if [ -e $HOME/.Xresources ]
then
	echo "... .Xresources found."
else
	touch $HOME/.Xresources
fi

#rework of user in config.yaml
cd src
rm -f config.yaml
cp defaults/config.yaml .
sed -i -e "s/USER/$USER/g" config.yaml

#file didn't excist for me, so test and touch
if [ -e $HOME/.config/polybar/config ]
then
        echo "... polybar/config found."
else
	mkdir $HOME/.config/polybar
        touch $HOME/.config/polybar/config
fi

#backup, configure and set theme to 000
cp -r ../scripts/* /home/$USER/.config/polybar/
mkdir $HOME/Backup
python i3wm-themer.py --config config.yaml --backup $HOME/Backup
python i3wm-themer.py --config config.yaml --install defaults/

echo ""
echo "Read the README.md"

