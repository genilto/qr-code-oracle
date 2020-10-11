CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED GENERATE_QRCODE AS
import java.sql.*;
import oracle.sql.*;
import oracle.jdbc.driver.OracleDriver;
import java.io.OutputStream;
import com.genilto.qrcode.QRCode;

/**********************************************************************************
* Creation: Genilto Vanzin
* Purpose.: Gerar Um Arquivo de imagem contendo o QRCode com o texto informado e 
*           gravar diretamente no campo blob da tabela
* References: 
*   A classe java criada "com.genilto.qrcode.QRCode" faz uso das Classes e APIs do 
*   projeto Open Source ZXING do Google: https://code.google.com/p/zxing
*   responsáveis pela geração do QRCode. Foram removidas rotinas de geração
*   de outros tipos de Códigos de Barras deixando apenas as relativas ao QRCode, 
*   criando-se também uma nova biblioteca personalizada para possibilitar a 
*   chamada através deste Java Compilado
**********************************************************************************/
public class SimpleQRCode
{
    /**
     * Gera um arquivo de imagem de QRCode e grava na tabela com campo Blob
     */
    public static String generateQRCode(int imageID, String qrCodeText, int imageSize, String imageType) throws Exception
    {
        try
        {
          // Recupera a conexao default ao oracle
          Connection conn = new OracleDriver().defaultConnection();
          
          // Cria o Statement
          Statement stmt = conn.createStatement();

          // Busca a linha da tabela onde a imagem deverá ser carregada
          ResultSet rs = stmt.executeQuery("SELECT image_blob FROM tbl_qrcode_image WHERE image_id = "+imageID+" for update");
          
          // Verifica se encontrou o registro
          if(rs.next())
          {
            // Busca o campo Blob que deverá ser escrito
            Blob blob = rs.getBlob("image_blob");
            
            // Busca o OutputStream para o arquivo
            OutputStream bout = ((BLOB) blob).getBinaryOutputStream();
            
            // Gera o QRCode diretamente no OutputStream do campo Blob da Tabela
            QRCode.generateQRCode(qrCodeText, imageSize, imageSize, bout, imageType);
            
            // Fecha o Stream
            bout.close();
            
            // Faz o commit da transação
            conn.commit();
          }
          else
          {
            return "Não encontrado registro com ID: "+imageID;
          }
          rs.close();
        }
        catch (Exception e)
        {
          return e.toString()+" - "+e.getMessage();
        }
        
        // Caso tenha ocorrido tudo corretamente, retorna OK
        return "OK";
    }
}
/
