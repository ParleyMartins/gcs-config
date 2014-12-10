Integração contínua e build automatizada Noosfero

#Como servidor padrão, será utilizado o apache. Lembre-se de EDITAR o arquivo noosfero (dentro desta pasta), substituindo o ServerName pelo nome (ou ip) do seu servidor

#Para subir o noosfero em qualquer outro lugar que não seja o jenkins, você deverá editar algumas configurações dos scripts (endereço da pasta onde o noosfero será clonado)
=====


na sua pasta raiz (~) clone o repositório:
$ git clone https://github.com/ParleyMartins/gcs-config.git

entre na pasta gcs-config e execute o script install-basics (como sudo):
\# ./install-basics.sh

(A 'hora certa' de seguir adiante é quando o a página http://your-host:8080/pluginManager/available mostra os plugins disponíveis. Enquanto isso não acontece, o jenkins não consegue instalar nenhum plugin, mesmo pela linha de comando)
$./jenkins-job.sh

A instalação dos plugins será concluída. Espere mais um tempo, enquanto o repositório é clonado (depende da velocidade da sua conexão com a internet) e rode o mesmo script novamente
$./jenkins-job.sh

Após isso, abra o jenkins na pagina inical http://localhost:8080 e configure os passos da build, seguindo os seguintes passos:
1- ~/teste.sh
2- Invoke Rake (deixe o campo de tasks em branco)
3- ~/build.sh
4- ~/destroy_build.sh (Se não quiser destruir a build. para ver o noosfero em execução, não utilize esse passo, mas lembre-se de que a build falhará na próxima execução, já que o processo ainda estará rodando e o banco de dados continua a existir)

Salve e clique em build now para ter o noosfero em integração contínua e build automatizada.
