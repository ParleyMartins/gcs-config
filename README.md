Integração contínua e build automatizada Noosfero

#Como servidor padrão, será utilizado o apache. Lembre-se de EDITAR o arquivo noosfero (dentro desta pasta), substituindo o ServerName pelo nome (ou ip) do seu servidor

#Para subir o noosfero em qualquer outro lugar que não seja o jenkins, você deverá editar algumas configurações dos scripts (endereço da pasta onde o noosfero será clonado)
=====


na sua pasta raiz (~) clone o repositório:
$ git clone https://github.com/ParleyMartins/gcs-config.git

entre na pasta gcs-config e execute o script install-basics (como sudo):
\# ./install-basics.sh

Após isso, espere um pouco e rode o script jenkins-job até obter sucesso (não terá a mensagem no final de que ./script/quick-start não existe). Repita a operação, se necessário. O jenkins demora algum tempo para ‘deixar’ instalar plugins, por isso, ocorrem falhas nas primeiras tentativas. Isso pode levar até 10 minutos ou mais.
$./jenkins-job.sh

Após isso, abra o jenkins na pagina inical http://localhost:8080 e configure os passos da build, seguindo os seguintes passos:
1- ~/teste.sh
2- Invoke Rake (deixe o campo de tasks em branco)
3- ~/build.sh
4- ~/destroy_build.sh (Se não quiser destruir a build. para ver o noosfero em execução, não utilize esse passo, mas lembre-se de que a build falhará na próxima execução, já que o processo ainda estará rodando e o banco de dados continua a existir)

Salve e clique em build now para ter o noosfero em integração contínua e build automatizada.
