#!/bin/bash

echo "#################################################"
echo "#       Instalacao Frente de caixa Linux        #"
echo "#################################################"

yum -y install dialog
yum -y install make
rpm -Uvh xdialog-2.3.1-6.i386.rpm

Xdialog  --wrap --title "Instalação "\
         --msgbox 'Iniciando Instalação frente de caixa RPdvWL' 8 60
sleep 2s

#Criando Diretórios
    echo "Aguarde... Criando Diretórios"
    mkdir /usr/include/bemafiscal
sleep 2s
#Declaração de Variaveis
	echo "Aguarde... Declarando Variáveis"
	RPDirLib=/usr/local/lib
	RPDirArqDar=/usr/local/share/Daruma
	RPDirFrente=/home/rpdv/frente
	RPDirSO=/home/rpdv/frente/so
	LocalAA=/usr/include/bemafiscal/
	LocalBB=/usr/lib/
	LocalCC=/usr/share/doc/
	DirBema=Bibliotecas/Bematech
	DirSweda=Bibliotecas/Sweda
	DirGertec=home/rpdv/frente/Bibliotecas/Gertec 
	DirEpson=home/rpdv/frente/Bibliotecas/Epson
	DirSITEF=home/rpdv/frente/Bibliotecas/SITEF

## Detecta a distro (Thiago Brizola)
        echo "#####################################################################################"
        echo "# Aguarde... Verificando Versão Linux                                                "
        echo "# Usuario               : `whoami`                                                   "
        echo "# Diretorio home        : $HOME                                                      "
        echo "# Distribuicao          : `cat /etc/issue`                                           "
        echo "# O sistema operacional : `uname -o` e o kernel é `uname -r` (64/32) bit `uname -m`  "
        echo "#####################################################################################"
	sleep 3s

# Instala...
echo "Aguarde... INSTALANDO bibliotecas DARUMA"
echo "------------------------------------------"
  echo "Aguarde... VERIFICANDO Diretórios DARUMA"
    BibDar=Bibliotecas/Daruma
    for iDar in \
	$BibDar/Daruma32.h \
	$BibDar/libDaruma32.a \
	$BibDar/libDaruma32.so \
	$BibDar/teste_linux.dat
     do
	   dir=$(dirname $iDar)
	   cp -a ./$iDar $RPDirLib
       cp -a ./$iDar $RPDirFrente
	   cp -a ./$iDar $RPDirSO
	   chown root: $RPDirLib
    done
	echo "Aguarde... Criando Pasta de Biblioteca"
	mkdir -p $RPDirArqDar
	echo "Aguarde... Efetivando permissões"
	chmod 777 $RPDirLib/*.*
	chmod 777 $RPDirFrente/*.*
  	chmod 777 $RPDirSO/*.*
	chmod 777 $RPDirArqDar
sleep 3s
echo "Aguarde... Eliminando Arquivos Temporários"
	rm -rf $RPDirArqDar/*.*
echo "------------------------------------------"
sleep 2s

echo "Aguarde... INSTALANDO bibliotecas BEMATECH"
echo "------------------------------------------"
       cd ./$DirBema
       libbematech=$(ls libbemafiscal.so.*.*);
	   cd -
       rm -rf /usr/lib/libbemafiscal*
	   rm -rf /usr/lib/libbemamfd*
       cp ./$DirBema/declares.h $LocalAA  
       cp  ./$DirBema/$libbematech $LocalBB
       #cp ./$DirBema/libbemafiscal.so.7 $LocalBB
       cp ./$DirBema/libbemafiscal.so $LocalBB
       cp ./$DirBema/libbemafiscal.a $LocalBB
       cp ./$DirBema/libbemamfd.so $LocalBB	
       cp ./$DirBema/libbemamfd2.so $LocalBB	
       #cp ./$DirBema/bemaconfig.xml /etc
       #cp ./$DirBema/bemafi.xml /etc	   
       mkdir -p /usr/share/doc/libbemafiscal
       chmod 777 /usr/share/doc/libbemafiscal
       chmod 755 /etc/bemaconfig.xml
	   chmod 755 /etc/bemafi.xml
	   echo "Aguarde... Criando Links Dinâmicos de Bibliotecas BEMATECH"
	   ln -sf $LocalBB/libbemafiscal.so.$libbematech $LocalBB/libbemafiscal.so.7
       echo "----------------------------------------------------------"
sleep 3s

echo "Aguarde... INSTALANDO bibliotecas SWEDA"
echo "------------------------------------------"
     cd ./$DirSweda  
     libsweda1=$(ls libconvecf.so.*.*);
	 libsweda2=$(ls libswmfd.so.*.*);
	 cd - 
     rm -rf /home/rpdv/frente/so/libsw*
	 rm -rf /home/rpdv/frente/so/libconv*
	 rm -rf /home/rpdv/frente/libsw*
	 rm -rf /home/rpdv/frente/libconv*
     cp ./$DirSweda/$libsweda1 /home/rpdv/frente/so
	 cp ./$DirSweda/$libsweda2 /home/rpdv/frente/so
     cp /home/rpdv/frente/so/libsw*.* /home/rpdv/frente
     cp /home/rpdv/frente/so/libconv*.* /home/rpdv/frente
   sleep 2s
   echo "Aguarde... Criando Links Dinâmicos de Bibliotecas SWEDA"
   sleep 5s
   cd /home/rpdv/frente/so
   ##Versão Nova ConvECF
   ln -f -s $libsweda1 libconvecf.so.0
   ln -f -s libconvecf.so.0 libconvecf.so
   ##Versão Nova LIBSWMFD
   ln -f -s $libsweda2 libswmfd.so.0
   ln -f -s libswmfd.so.0 libswmfd.so
   echo "-------------------------------------------------"
   
   ##libGertec 
   echo "Aguarde... INSTALANDO bibliotecas GERTEC"
   cd /$DirGertec 
   libgertec=$(ls libTecMgertec.so.*);
   cd -
   rm -rf /home/rpdv/frente/libTecMgertec*
   rm -rf /home/rpdv/frente/so/libTecMgertec*
   cp /$DirGertec/$libgertec /home/rpdv/frente/so
   ln -s -f /home/rpdv/frente/so/$libgertec /home/rpdv/frente/so/libTecMgertec.so.1
   ln -s -f /home/rpdv/frente/so/libTecMgertec.so.1 /home/rpdv/frente/so/libTecMgertec.so
   echo "-----------------------------------------"

##lib Epson
echo "Aguarde... INSTALANDO bibliotecas EPSON"
   cd /$DirEpson  
   libepson1=$(ls libInterfaceEpson.so.*.*);
   libepson2=$(ls libInterfaceEpsonNF.so.*.*);
   cd -
rm -rf /home/rpdv/frente/so/libInterfaceEpsonNF*
rm -rf /usr/local/lib/libInterfaceEpsonNF*
rm -rf /home/rpdv/frente/so/libInterfaceEpson*
rm -rf /usr/local/lib/libInterfaceEpson*

cp  /$DirEpson/$libepson2 /usr/local/lib
cp  /$DirEpson/libInterfaceEpsonNF.a /usr/local/lib
ln -s -f /usr/local/lib/$libepson2 /usr/local/lib/libInterfaceEpsonNF.so.1

cp  /$DirEpson/$libepson1 /usr/local/lib
cp  /$DirEpson/libInterfaceEpson.a /usr/local/lib
ln -s -f /usr/local/lib/$libepson1 /usr/local/lib/libInterfaceEpson.so.4

cp  /$DirEpson/$libepson2 /home/rpdv/frente/so
cp  /$DirEpson/libInterfaceEpson.a /home/rpdv/frente/so
ln -s -f /home/rpdv/frente/so/$libepson2 /home/rpdv/frente/so/libInterfaceEpsonNF.so.1

cp  /$DirEpson/$libepson1 /home/rpdv/frente/so
cp  /$DirEpson/libInterfaceEpson.a /home/rpdv/frente/so
ln -s -f /home/rpdv/frente/so/$libepson1 /home/rpdv/frente/so/libInterfaceEpson.so.4
echo "-----------------------------------------"

echo "Aguarde... INSTALANDO bibliotecas SITEF"
rm -rf /home/rpdv/frente/so/libclisitef*
rm -rf /home/rpdv/frente/so/libemv.so
rm -rf /home/rpdv/frente/so/rechargeRPC.so
rm -rf /home/rpdv/frente/so/libemv.so
rm -rf /home/rpdv/frente/so/Cheque.txt
cp /$DirSITEF/* /home/rpdv/frente/so
echo "-----------------------------------------"

echo "Aguarde... INSTALANDO bibliotecas LIB SUREMARK"
cd "`dirname "$0"`";

    TGCS_VERSION1=1;
    TGCS_VERSION2=3;
    TGCS_VERSION3=6;
    TGCS_VERSION4=0;

    echo "Copiando biblioteca para /usr/lib ...";
    cp /home/rpdv/frente/so/libtgcssuremark.so.$TGCS_VERSION1.$TGCS_VERSION2.$TGCS_VERSION3.$TGCS_VERSION4 /usr/lib;

    echo "Criando links simbolicos...";
    ln -sf /usr/lib/libtgcssuremark.so.$TGCS_VERSION1.$TGCS_VERSION2.$TGCS_VERSION3.$TGCS_VERSION4 /usr/lib/libtgcssuremark.so.$TGCS_VERSION1.$TGCS_VERSION2.$TGCS_VERSION3;
    ln -sf /usr/lib/libtgcssuremark.so.$TGCS_VERSION1.$TGCS_VERSION2.$TGCS_VERSION3 /usr/lib/libtgcssuremark.so.$TGCS_VERSION1.$TGCS_VERSION2;
    ln -sf /usr/lib/libtgcssuremark.so.$TGCS_VERSION1.$TGCS_VERSION2 /usr/lib/libtgcssuremark.so.$TGCS_VERSION1;
    ln -sf /usr/lib/libtgcssuremark.so.$TGCS_VERSION1 /usr/lib/libtgcssuremark.so;
echo "-----------------------------------------"

ldconfig
echo "Aguarde... Efetivando Permissões das Bibliotecas"
sleep 2s
    chmod 777 /home/rpdv/frente/frente
	chmod 777 /home/rpdv/frente/*.*
	chmod 777 /home/rpdv/frente/*.*
	chmod 777 /home/rpdv/frente/so/*.*
	chmod 777 /home/rpdv/frente/so/*.*
# Atualiza o cache de bibliotecas
rm -rf /etc/gdm/custom.conf
cp /home/rpdv/frente/custom.conf /etc/gdm/
rm -rf /etc/sudoers
cp /home/rpdv/frente/sudoers /etc/
chmod 0440 /etc/sudoers
echo "Aguarde... INSTALANDO Cache de bibliotecas..."
export LD_LIBRARY_PATH=/home/rpdv/frente/

echo ""
echo "###=====================================Configuracao dos PDV=====================================###"
echo ""

Xdialog --wrap --title "RP Info Sistemas LTDA."\
        --yesno 'Deseja instalar os editore nano/mcedit ?' 5 60
if [ $? = 0 ]; then 
    echo  'Download e Instalação Editor nano ... ';
    yum -y install nano;
    sleep 1s;
    echo "Download e Instalação Editor mcedit ... ";
    yum -y install mc;
    echo "Download e Instalação Openssh-server ...";
    sleep 1s;
    yum -y install openssh-server;
else echo "OK";
fi 

Xdialog --wrap --title "RP Info Sistemas LTDA."\
        --yesno 'Sua placa serial off board é um netmos 9865 ? Se for gostaria de instalar agora?' 10 60
if [ $? = 0 ]; then
    sudo wget -c http://www.drivers-download.com/Drv/MosChip/MCS9865/MCS9865_Linux.tar.gz;
    echo "Comparar Kernel";
    uname -a;
    rpm -qa |grep kernel;
    tar zxf MCS9865_Linux.tar.gz;
    cd MCS9865_V1.0.0.9;
    yum groupinstall "Development Tools" -y;
    make;
    make install;
    dmesg | grep ttyD;
    echo "modprobe mcs9865" >> /etc/rc.local;
    echo "modprobe mcs9865-isa" >> /etc/rc.local;
    echo "ln -s -f /dev/ttyD0 /dev/ttyS2" >> /etc/rc.local;
    ln -s -f /dev/ttyD0 /dev/ttyS2;
    echo "ln -s -f /dev/ttyD1 /dev/ttyS3" >> /etc/rc.local;
    ln -s -f /dev/ttyD1 /dev/ttyS3;
else echo "OK";
fi

Xdialog --wrap --title "RP Info Sistemas LTDA."\
        --yesno 'Deseja Ativar Numlock ao iniciar SO ?' 8 60
if [ $? = 0 ]; then 
    rpm -Uvh /home/rpdv/frente/numlockx-1.2-2.el6.nux.i686.rpm;
    /usr/bin/numlockx on;
else echo "OK";
fi


Xdialog --wrap --title "RP Info Sistemas LTDA."\
        --yesno 'Deseja habilitar login automático ?' 8 60
if [ $? = 0 ]; then 
    mv /etc/gdm/custom.conf /etc/gdm/custom-old.conf;
    echo '[daemon]' >> /etc/gdm/custom.conf;
    echo 'AutomaticLoginEnable=true' >> /etc/gdm/custom.conf;
    echo 'AutomaticLogin=root' >> /etc/gdm/custom.conf;
    echo '[security]' >> /etc/gdm/custom.conf;
    echo '[xdmcp]' >> /etc/gdm/custom.conf;
    echo '[greeter]' >> /etc/gdm/custom.conf;
    echo '[chooser]' >> /etc/gdm/custom.conf;
    echo '[debug]' >> /etc/gdm/custom.conf;
else echo "OK";
fi

Xdialog --wrap --title "RP Info Sistemas LTDA."\
        --yesno 'Deseja instalar o vnc ?' 8 60
if [ $? = 0 ]; then 
    yum -y install seahorse;
    echo "Instalando pacotes VNC 1/2";
    sleep 3;
    yum -y install vino;
    echo "INstalando pacotes VNC 2/2";
    sleep 3;
else echo "OK";
fi

Xdialog --wrap --title "RP Info Sistemas LTDA."\
        --yesno 'Deseja desativar MODEM-MANAGER ? ' 8 60
if [ $? = 0 ]; then 
    rm -rf /usr/share/dbus-1/system-services/org.freedesktop.ModemManager.service;
    mv /usr/sbin/modem-manager /usr/sbin/modem-manager-old;
else echo "OK";
fi

Xdialog --wrap --title "RP Info Sistemas LTDA."\
	--yesno 'Deseja identificar dispositivos USB/COM : ' 8 60
if [ $? = 0 ]; then
    echo 'Dispositivos COM ttyS ... ';
    dmesg | grep ttyS;
    dmesg | grep ttyD;
    echo '';
    echo 'Conecte agora o dispositivo USB';
    sleep 10s;
    tail -n 30 /var/log/messages;
else echo 'OK';
fi

sleep 5s

Xdialog --backtitle "Lista de Arquivos de Configuracao" --title "Lista" \
        --checklist "Todos estes arquivos sao de grande importancia \n\
        para o funcionamento do pdv\n\n
        Selecione os arquivos para edicao " 30 95 6 \
        "config.cfg" "Arquivo de Configuracao (Impressora/scanner ... etc) " ON \
        "sistema.ini" "Configuracao de comunicacao com server UN e estao impressora " ON \
        "CliSiTef.ini" "Arquivo de configuracao T.E.F " ON \
        "BemaFI32.ini" "Configuracao adicional para impressoras Bematech " on 2> /home/rpdv/frente/checklist.sh

retval=$?

choice=`cat /home/rpdv/frente/checklist.sh`
rm -rf /home/rpdv/frente/checklist.sh
ln -s -f /etc/sudoers /home/rpdv/frente/so/sudoers
ln -s -f /home/rpdv/frente/config.cfg /home/rpdv/frente/so/config.cfg
ln -s -f /home/rpdv/frente/sistema.ini /home/rpdv/frente/so/sistema.ini
ln -s -f /home/rpdv/frente/CliSiTef.ini /home/rpdv/frente/so/CliSiTef.ini
ln -s -f /home/rpdv/frente/BemaFI32.ini /home/rpdv/frente/so/BemaFI32.ini

case $retval in
  0)
    echo sudo gedit  ${choice////; sudo gedit } >> /home/rpdv/frente/editar.sh;;
  1)
    echo "Processo Cancelado.";;
  255)
    echo "Janela Fechada.";;
esac

chmod 777 /home/rpdv/frente/editar.sh
/home/rpdv/frente/editar.sh
rm -rf /home/rpdv/frente/editar.sh

Xdialog --wrap --title "RP Info Sistemas LTDA."\
        --yesno 'Deseja desabilitar Serviços do linux ?' 8 60
if [ $? = 0 ]; then
    setup;

else echo "OK";
fi

Xdialog --wrap --title "RP Info Sistemas LTDA."\
        --msgbox 'Instalacao concluida com sucesso !!! ' 8 60

export LD_LIBRARY_PATH=/home/rpdv/frente/so

cp /home/rpdv/frente/Frente.desktop /root/Área\ de\ Trabalho/
mkdir /root/.config/autostart
cp /home/rpdv/frente/sudo.desktop /root/.config/autostart/
clear

echo "Agenda ssh ao iniciar"
chkconfig sshd on 
service sshd reload
echo "ssh OK"

#  ==============  Atualizações ============== #

# Scritp Criado Por Thiago Brizola

#Scritp Atualizado por Fernando Zanol
#data : 31/10/2014

#Scritp Atualizado por Camilo
#data : 08/03/2016

#Scritp Atualizado por Lucas Chinarelli
#data : 14/03/2017