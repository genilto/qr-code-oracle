package com.genilto.qrcode;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.OutputStream;
import java.util.Hashtable;

import javax.imageio.ImageIO;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;


public class QRCode {

	public static void main(String[] args) 
	{
		 
	}
	
	public static void generateQRCode(String content, int width, int height, OutputStream outputStream, String imageFormat) throws Exception 
	{ 
	    
		// Create the ByteMatrix for the QR-Code that encodes the given String
        Hashtable hintMap = new Hashtable();
        hintMap.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.L);
        
        // Create the ByteMatrix for the QR-Code that encodes the given String
        BitMatrix bitMatrix = new QRCodeWriter().encode(content, BarcodeFormat.QR_CODE, width, height, hintMap);
        
        // Make the BufferedImage that are to hold the QRCode
        int matrixWidth = bitMatrix.getWidth();
        
        BufferedImage image = new BufferedImage(matrixWidth, matrixWidth, BufferedImage.TYPE_INT_RGB);
        image.createGraphics();
 
        Graphics2D graphics = (Graphics2D) image.getGraphics();
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0, 0, matrixWidth, matrixWidth);
        
        // Paint and save the image using the ByteMatrix
        graphics.setColor(Color.BLACK);
 
        for (int i = 0; i < matrixWidth; i++)
            for (int j = 0; j < matrixWidth; j++)
                if (bitMatrix.get(i, j))
                    graphics.fillRect(i, j, 1, 1);
        
        // Escreve a imagem para o OutputStream
        ImageIO.write(image, imageFormat, outputStream);

	}
	
	public static void generateQRCode(String content, int width, int height, OutputStream outputStream) throws Exception 
	{ 
		generateQRCode(content, width, height, outputStream, "jpg");
	}
}
