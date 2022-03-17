/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Wildar
 */
package dbutils;
public class DBConnect {
  
  public static PDO getCon(){
      return new PDO("jdbc:mysql://localhost/chcl", "root", "");
  }
  
}

