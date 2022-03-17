package dbutils;


import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;

import javax.xml.bind.DatatypeConverter;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;

public class XcelReader{
    private ArrayList<String> targetHead;
    private String path;
    private String xcelData;
    private File xls;
    
    public XcelReader(){}
    
    public XcelReader(String fileData, String directory, ArrayList rowHead){
        this.targetHead = rowHead;
        this.xcelData = fileData;
        this.path = directory;
    }
    
    public XcelReader(String fileData, String directory, String[] rowHead){
        this.targetHead = toList(rowHead);
        this.xcelData = fileData;
        this.path = directory;
    }
    
    public XcelReader(String fileData, String directory){
        this.xcelData = fileData;
        this.path = directory;
    }
    
    private ArrayList<String> toList(String[] arr){
        ArrayList<String> r = new ArrayList<String>();
        for(String e : arr){
            r.add(e);
        }
        return r;
    }
    
    public void setFileData(String base64Data){
        this.xcelData = base64Data;
    }
    
    public void setDirectory(String dir){
        this.path = dir;
    }
    
    public void setRowHead(ArrayList<String> rowHead){
        this.targetHead = rowHead;
    }
    
    public void setRowHead(String[] rowHead){
        this.targetHead = toList(rowHead);
    }
    
    
    private static String uploadFile(String urlData, String path, String ext){
        String[] strings = urlData.split(",");
        String extension = ext == null ? strings[0].replaceAll("^data:(?:.+?)/(.+?);(.+?)$", "$1") : ext,
               filename = System.currentTimeMillis()+"."+extension;
        //convert base64 string to binary data
        byte[] data = DatatypeConverter.parseBase64Binary(strings[1]);
        File file = new File(path+filename);
        try (OutputStream outputStream = new BufferedOutputStream(new FileOutputStream(file))) {
            outputStream.write(data);
        } catch (IOException e) {
            filename = null;
            e.printStackTrace();
        }
        return filename;
    }
    
    public void flush(){
        xls.delete();
    }
    
    public ArrayList<HashMap<String,String>> read() throws Exception{
        String name = uploadFile(this.xcelData, this.path, "xls");
        ArrayList<HashMap<String,String>> r = null;
        if(name == null){
            throw new Exception("Invalid file given for importation !");
        }
        else {
            xls = new File(path+name);
            r = extractData();
        }
        return r;
    }
    
    private ArrayList<HashMap<String,String>> extractData() throws Exception {
        ArrayList<HashMap<String,String>> sheetExtraction = new ArrayList<>();
        boolean badformat = false;
        try {
            FileInputStream fs = new FileInputStream(xls);
            HSSFWorkbook wb = new HSSFWorkbook(fs);
            HSSFSheet sheet = wb.getSheetAt(0);

            boolean startHead = false, startData = false;
            int totalDetection = 0, k = 0;
            String rowHead;
            HashMap<Integer, String> givenHead = new HashMap<>();
            HashMap<String, String> rowExtraction = new HashMap<>();


            FormulaEvaluator formula = wb.getCreationHelper().createFormulaEvaluator();

            String data;
            double value;
            for(Row row : sheet){
                if(startHead){
                    if(totalDetection != targetHead.size()){
                        badformat = true;
                        break;
                    }
                    startData = true;
                    startHead = false;
                }
                else if(!startData){
                    givenHead = new HashMap<>();
                }
                if(startData){
                    rowExtraction = new HashMap<>();
                }
                k = 0;
                for(Cell cell : row){
                    rowHead = "";
                    switch(formula.evaluateInCell(cell).getCellType()){
                        case Cell.CELL_TYPE_NUMERIC:
                            value = cell.getNumericCellValue();
                            rowHead = value+"";
                            if(startData){
                                if(Utils.isInTarget(targetHead,givenHead.get(k))){
                                    rowExtraction.put(Utils.getTarget(targetHead,givenHead.get(k)), value+"");
                                }
                            }
                            break;
                        case Cell.CELL_TYPE_STRING:
                            data = cell.getStringCellValue();
                            if(!startHead && givenHead.size() == 0 && Utils.isInTarget(targetHead,Utils.setPonctuationLess(data))){
                                startHead = true;
                            }
                            if(startHead){
                                if(Utils.isInTarget(targetHead,Utils.setPonctuationLess(data))) {
                                    totalDetection++;
                                }
                            }
                            if(startData){
                                if(Utils.isInTarget(targetHead,givenHead.get(k))){
                                    rowExtraction.put(Utils.getTarget(targetHead,givenHead.get(k)), data);
                                }
                            }
                            else{
                                rowHead = Utils.setPonctuationLess(data);
                            }
                            break;
                    }
                    if(!startData) {
                        givenHead.put(k, rowHead);
                    }
                    k++;
                }
                if(startData){
                    sheetExtraction.add(rowExtraction);
                }
            }
        } catch (Exception e) {
            sheetExtraction = null;
            e.printStackTrace();
        }
        if(badformat){
            throw new Exception("Error ! Excel file content badly formatted !");
        }
        return sheetExtraction;
    }

}
