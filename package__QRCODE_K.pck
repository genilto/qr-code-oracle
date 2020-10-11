CREATE OR REPLACE PACKAGE qrcode_k IS

/**********************************************************************************
* Creation: Genilto Vanzin
* Purpose.: Package com rotinas responsáveis pela geração de uma imagem 
*           com o QRCode representando uma String passada
**********************************************************************************/

  -----------------------------------------------------------------------
  -- Created By: Genilto Vanzin
  -- Purpose...: Gerar um arquivo QRCode com o Texto informado
  -- PARAMETERS:
  --  * P_QRCODE_DESC...: Conteúdo a ser gerado no QRCode
  --  * P_IMAGE_SIZE....: Tamanho do QRCode a ser gerado em pixels
  --  * P_IMAGE_TYPE....: Tipo da imagem a ser gerada (png, jpg, bmp)
  --  * PX_ERROR_MESSAGE: Caso o retorno da rotina seja zero, este
  --                      campo estará carregado com o erro ocorrido
  -- RETURN....: Caso o retorno seja "OK" o processo foi concluído com
  --             sucesso. Caso contrário retorna o erro ocorrido
  -----------------------------------------------------------------------
  FUNCTION Generate_QRCode(p_qrcode_desc     IN VARCHAR2
                         , p_image_size      IN NUMBER
                         , p_image_type      IN VARCHAR2
                         , px_error_message OUT VARCHAR2) RETURN NUMBER;

END qrcode_k;
/
CREATE OR REPLACE PACKAGE BODY qrcode_k IS

  -----------------------------------------------------------------------
  -- Created By: Genilto Vanzin
  -- Purpose...: Gerar um arquivo QRCode com o Texto informado
  -- PARAMETERS:
  --  * P_IMAGE_ID.....: ID do registro onde a imagem será carregada
  --                     O registro precisa já estar criado com o campo
  --                     da imagem carregado com um empty_blob para que
  --                     a rotina funcione corretamente
  --  * P_QRCODE_DESC..: Conteúdo a ser gerado no QRCode
  --  * P_IMAGE_SIZE...: Tamanho do QRCode a ser gerado em pixels
  --  * P_IMAGE_TYPE...: Tipo da imagem a ser gerada (png, jpg, bmp)
  -- RETURN....: Caso o retorno seja "OK" o processo foi concluído com
  --             sucesso. Caso contrário retorna o erro ocorrido
  -----------------------------------------------------------------------
  FUNCTION Generate_QRCode(p_image_id    IN NUMBER
                         , p_qrcode_desc IN VARCHAR2
                         , p_image_size  IN NUMBER
                         , p_image_type  IN VARCHAR2) RETURN VARCHAR2 AS
  LANGUAGE JAVA NAME 'SimpleQRCode.generateQRCode(int, java.lang.String, int, java.lang.String) return java.lang.String';

  -----------------------------------------------------------------------
  FUNCTION Generate_QRCode(p_qrcode_desc     IN VARCHAR2
                         , p_image_size      IN NUMBER
                         , p_image_type      IN VARCHAR2
                         , px_error_message OUT VARCHAR2) RETURN NUMBER IS
    
    -- Busca o maior ID da tabela
    CURSOR c_next IS
    SELECT Nvl(MAX(tqi.image_id), 0) image_id
      FROM tbl_qrcode_image tqi;
  
    w_image_id NUMBER;
    w_retorno  VARCHAR2(32000);
    
  BEGIN
    
    px_error_message := NULL;

    -- Valida as informações
    IF p_qrcode_desc IS NULL THEN
      px_error_message := 'Deverá ser informado um conteúdo para geração do QRCode';
      RETURN 0;
    END IF;

    IF Nvl(p_image_size, 0) <= 0 THEN
      px_error_message := 'O tamanho do QRCode deve ser maior do que Zero';
      RETURN 0;
    END IF;

    IF p_image_type NOT IN ('png', 'jpg', 'bmp') THEN
      px_error_message := 'O formato da imagem a ser gerada deve estar entre: png, jpg, bmp';
      RETURN 0;
    END IF;

    -- Busca o ID atual da Tabela
    OPEN c_next;
    FETCH c_next INTO w_image_id;
    CLOSE c_next;
    
    -- Incrementa o ID da imagem
    w_image_id := Nvl(w_image_id, 0) + 1;
    
    -- Insere o novo registro
    BEGIN
      INSERT INTO tbl_qrcode_image
             (
               image_id
             , image_desc
             , image_size
             , image_type
             , image_blob
             , creation_date
             )
         VALUES 
             (
               w_image_id
             , Substr(p_qrcode_desc, 1, 4000)
             , p_image_size
             , p_image_type
             , empty_blob()
             , SYSDATE
             );
    EXCEPTION
      WHEN OTHERS THEN
        px_error_message := 'Erro ao inserir em tgr_qrcode_image (ID: '||w_image_id||'): '||SQLERRM;
        RETURN 0;
    END;
    
    -- Faz o commit do Registro, para garantir o MAX
    COMMIT;
    
    -- Chama a rotina Java que irá gerar o QRCode e carregar para o campo Blob da Tabela
    -- Esta rotina fará o Commit das informações
    w_retorno := Generate_QRCode(p_image_id    => w_image_id
                               , p_qrcode_desc => Substr(p_qrcode_desc, 1, 4000)
                               , p_image_size  => p_image_size
                               , p_image_type  => p_image_type);
    
    -- Verifica se ocorreu algum erro na geração do QRCode
    IF w_retorno != 'OK' THEN
      px_error_message := w_retorno;
      RETURN 0;
    END IF;
    
    -- Retorna o ID do registro de Imagem gerado
    RETURN w_image_id;
    
  EXCEPTION
    WHEN OTHERS THEN
      px_error_message := 'Erro: '||SQLERRM;
      RETURN 0;
  END Generate_QRCode;

END qrcode_k;
/
