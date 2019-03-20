# Comandos para auxiliar as alterações no modo gráfico no GNU/Linux

# Altera a inicialização do sistema para o modo texto
sudo systemctl set-default multi-user.target

# Remove um ambiente gráfico já instalado
# No exemplo seria removido o Gnome
sudo tasksel remove gnome-desktop

# Instalar um ambiente gráfico
# Após rodar o comando será exibido no prompt as opções para instalação
sudo tasksel

# Altera a inicialização do sistema para o modo gráfico
sudo systemctl set-default graphical.target
