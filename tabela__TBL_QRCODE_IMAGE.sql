CREATE TABLE tbl_qrcode_image
(
  image_id      NUMBER PRIMARY KEY,
  image_desc    VARCHAR2(4000),
  image_size    NUMBER,
  image_type    VARCHAR2(3),
  image_blob    BLOB,
  creation_date DATE NOT NULL
);
/
COMMENT ON TABLE tbl_qrcode_image IS 'Tabela que conterá as imagens de QRCode geradas. Armazena as imagens em campo Blob';
COMMENT ON COLUMN tbl_qrcode_image.image_id      IS 'ID único do registro';
COMMENT ON COLUMN tbl_qrcode_image.image_desc    IS 'Conteúdo gerado no QRCode';
COMMENT ON COLUMN tbl_qrcode_image.image_size    IS 'Tamanho da imagem em Pixel';
COMMENT ON COLUMN tbl_qrcode_image.image_type    IS 'Formato da Imagem gerada (png, jpg, bmp)';
COMMENT ON COLUMN tbl_qrcode_image.image_blob    IS 'Campo binário contendo a imagem do QRCode';
COMMENT ON COLUMN tbl_qrcode_image.creation_date IS 'Data de criação do registro';
