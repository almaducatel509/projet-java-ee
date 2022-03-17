/**
 * @author : Superga
 * @date : December, 31 2020
 * @description : Class Wrapper for database transaction inspired from php PDO object
 * */
package dbutils;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.ListIterator;

public class PDO {

    public static String driver = "com.mysql.cj.jdbc.Driver";
    private Connection connect;
    private Statement state;
    private ResultSet res;
    private ResultSetMetaData resMeta;
    private String prepareSql;
    private int running = 0;
    private ArrayList<String> effectiveArgs = new ArrayList<>();
    private ArrayList<HashMap> result = new ArrayList();
    private static String last_url = "", last_user = "", last_password = "";
    private static Connection last_conn = null;

    public PDO(String url, String user, String password){
        try{
            Class.forName(driver);
            url += "?useUnicode=true&useJDBCCompilantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
            if(last_conn == null || (last_conn != null && !url.equals(last_url) && !user.equals(last_user) && !password.equals(last_password))){
                connect = DriverManager.getConnection(url,user,password);
                last_conn = connect;
            }
            else{
                connect = last_conn;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    PDO() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    public void prepare(String sql){
        this.prepareSql = sql;
        closeCursor();
        getEffectiveArgs();
        result.clear();
        running = 0;
    }

    private void getEffectiveArgs(){
        effectiveArgs.clear();
        String el = "";
        boolean begin = false;
        for(int i = 0, j = prepareSql.length(); i < j; i++){
            if(!(prepareSql.charAt(i)+"").matches("[a-zA-Z0-9_]") || i == prepareSql.length()-1){
                begin = false;
                if(el.length() > 0){
                    if(i == prepareSql.length()-1 && (prepareSql.charAt(i)+"").matches("[a-zA-Z0-9_]"))
                        el += prepareSql.charAt(i);
                    effectiveArgs.add(el);
                    el = "";
                }
            }
            if(begin){
                el += prepareSql.charAt(i);
            }
            if(prepareSql.charAt(i) == ':'){
                begin = true;
            }
        }
    }

    private void decode(String arg, String value){
        prepareSql = prepareSql.replaceAll(":"+arg+"\\b", value == null ? "NULL" : "'"+(value.replaceAll("'", "\\\\\\\\'"))+"'");
    }

    private void decode(String arg, int value){
        prepareSql = prepareSql.replaceAll(":"+arg+"\\b", ""+value);
    }

    private void decode(String arg, double value){
        prepareSql = prepareSql.replaceAll(":"+arg+"\\b", ""+value);
    }

    private void decode(String arg, float value){
        prepareSql = prepareSql.replaceAll(":"+arg+"\\b", ""+value);
    }

    private void decode(String arg, boolean value){
        prepareSql = prepareSql.replaceAll(":"+arg+"\\b", ""+value);
    }

    private void request(){
        try{
            resMeta = res.getMetaData();
            HashMap<String, Object> list;
            while(res.next()){
                list = new HashMap();
                for(int i = 1; i <= resMeta.getColumnCount(); i++){
                    list.put(resMeta.getColumnName(i).toLowerCase(),res.getObject(i));
                    list.put(resMeta.getColumnName(i),res.getObject(i));
                }
                result.add(list);
            }
        }catch(Exception e){
        }
    }

    public void params(String key, String value){
        for(String p : effectiveArgs){
            if(p.equals(key)){
                decode(p,value);
            }
        }
    }

    public void params(String key, int value){
        for(String p : effectiveArgs){
            if(p.equals(key)){
                decode(p,value);
            }
        }
    }

    public void params(String key, double value){
        for(String p : effectiveArgs){
            if(p.equals(key)){
                decode(p,value);
            }
        }
    }

    public void params(String key, float value){
        for(String p : effectiveArgs){
            if(p.equals(key)){
                decode(p,value);
            }
        }
    }

    public void params(String key, boolean value){
        for(String p : effectiveArgs){
            if(p.equals(key)){
                decode(p,value);
            }
        }
    }

    public boolean execute(String[] params){
        boolean success = false;
        try{
            int k = 0;
            for(String p : effectiveArgs){
                if(k < params.length){
                    decode(p,params[k]);
                }
                else{
                    decode(p,"");
                }
                k++;
            }
            state = connect.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
            if(prepareSql.matches("^(?i)SELECT(.+?)$")){
                res = state.executeQuery(prepareSql);
                request();
            }else{
                state.executeUpdate(prepareSql);
                res = null;
            }
            success = true;
        }catch(Exception e){
            e.printStackTrace();
        }
        return success;
    }

    public boolean execute(){
        return execute(new String[]{});
    }

    public boolean execute(Object[] params){
        String list[] = new String[params.length];
        for(int i = 0, j = params.length; i < j; i++){
            list[i] = params[i].toString();
        }
        return execute(list);
    }

    public int rowCount(){
        return result.size();
    }

    public HashMap<String, Object> fetch(){
        if(running >= result.size())
            return null;
        HashMap<String, Object> el = result.get(running);
        running++;
        return el;
    }

    public boolean hasNext(){
        return running < result.size();
    }

    public void closeCursor(){
        try{
            res.close();
            state.close();
        }catch (Exception e){
        }
    }
}
