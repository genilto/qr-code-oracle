# qr-code-oracle

Geração de QR CODE utilizando Java em Banco de Dados Oracle

Este projeto faz uso do loadjava, um utilitário (shell) da oracle que faz a carga de classes java (jar) para o banco de dados. 

Também faz uso da possibilidade de utilizar Java Compilado diretamente no banco de dados Oracle, chamado de Java Source, é como se fosse uma Procedure normal, porém com código fonte em Java. Dessa forma, possibilitando a utilização de bibliotecas de QRCode já existentes na linguagem Java.

Para este projeto, foi utilizado a biblioteca zxing do google para geração do QRCode propriamente dito. Porém, a biblioteca original foi copiada do repositório orginal pra cá, e foram removidos todas as demais classes referente a geração de outros tipos de códigos de barras e outras coisas, deixando apenas o que se refere a geração de QRCode, de forma que o artefato final ficasse o mais leve possível para ser carregado para o Oracle.

Se você perceber, se você utilizar a biblioteca inteira do zxing, olha quantas possibilidades nós teríamos dentro do Oracle que são bem difíceis de conseguir normalmente por lá, não é mesmo?

Mais detalhes e vídeo do passo a passo em:
https://genilto.com/oracle-e-java-como-gerar-um-qr-code-loadjava-e-java-compilado/

# Instalação dos objetos no Oracle Database
-------
Abaixo estão os passos resumidos do que deve ser feito para instalar os objetos do projeto no banco de dados Oracle

##### Gerar o pacote jar com as bibliotecas para geração do QRCode.
Abra o projeto no Eclipse e exporte o jar do projeto utilizando o java 1.4 (isso é muito importante!). Para facilitar, já deixei o arquivo gerado e prontinho para subir para o banco:
**com.genilto.qrcode.jar**

##### Instalar essas bibliotecas no banco de dados Oracle, para que possam ser executadas através do PL/SQL.
Para isso é necessário fazer upload do arquivo "com.genilto.qrcode.jar" para o mesmo servidor onde está o banco de dados desejado. 
Com o arquivo no mesmo servidor do banco, executar o comando abaixo para carregar as classes java para o banco de dados
```bash
loadjava -verbose -synonym -resolve -user user/pass@base -grant APPS -fileout log.txt com.genilto.qrcode.jar
```
Preste atenção pois onde está "user/pass@base" você deve colocar o usuário, senha e instância do banco de dados desejada.

Caso necessário é possível executar o comando abaixo para eliminar as classes java que foram carregadas para o banco de dados
```bash
#dropjava -verbose -synonym -resolve -user user/pass@base -grant APPS -fileout log.txt com.genilto.qrcode.jar
```

##### Compilar os demais objetos do projeto diretamente no banco de dados
Para isso basta abrir os arquivos na sequencia abaixo utilizando o PLSQL Developer por exemplo, e compilar normalmente, gerando a tabela e compilando os objetos.
> OBS: Objetos criados com codificação ISO-8859-1

1. Criar a tabela que irá armazenar os QRCode gerados: 
**tabela__TBL_QRCODE_IMAGE.sql**

2. Compilar o Java Source que fará uso das bibliotecas que subimos através do loadjava:
**java_source__GENERATE_QRCODE.jsp**

3. Criar a package que será a API para utilização de nosso projeto:
**package__QRCODE_K.pck**

# Vídeo completo sobre o projeto

Criei um vídeo com todo o passo a passo do projeto para que fique mais fácil o entendimento, lá inclusive demonstro alguns problemas com o loadjava, quando este não está corretamente configurado na instância que você está, e o que você pode fazer para resolver.

Veja o vídeo em:
https://genilto.com/oracle-e-java-como-gerar-um-qr-code-loadjava-e-java-compilado/

# Outras possibilidades

A intenção deste projeto sempre foi mostrar como é possível utilizar classes java diretamente dentro do banco de dados Oracle Utilizando PLSQL. Por isso utilizei o exemplo do QRCode.

Conhecendo esse caminho, cria-se um novo mundo de possibilidades de desenvolvimento dentro do Oracle.

Dessa forma, também gostaria de deixar claro que essa não é a única forma de gerar QRCode dentro do Oracle, como pode inclusive não ser a melhor.

Por exemplo, existe o projeto do svetka17, que utiliza puramente PLSQL para fazer a geração do QRCode, também retornando um BLOB com o arquivo de imagem gerado. Eu não testei ainda a solução, mas se funcionar diretamente no PLSQL, eu acredito que seria uma solução muito mais fácil de ser implementada. Caso queiram testar:

https://github.com/svetka17/make_qr

Um abraço!
Espero ter ajudado.