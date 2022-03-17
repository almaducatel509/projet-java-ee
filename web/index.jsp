<%-- 
    Document   : login.jsp
    Created on : Sep 16, 2021, 10:01:19 PM
    Author     : Wildar
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.HashMap"%>
<%@page import="dbutils.PDO"%>
<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    boolean isSubmission = false, failed = true;
    String username = (String) request.getParameter("pseudo"),
           password = (String) request.getParameter("pass");
    if(username != null && password != null && username.length() > 0 && password.length() > 0){
        isSubmission = true;
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("select * from utilisateur where pseudo = :pseudo and pass = :password");
        db.params("pseudo", username);
        db.params("password", password);
        if(db.execute()){
            if(db.hasNext()){
                session.setAttribute("user", db.fetch());
                failed = false;
            }
        }
        if(!failed){
            response.sendRedirect("./panel");
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/ionicons/css/ionicons.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="./style.css">
        <title>Connection</title>
    </head>
    <body>
  <div class="body_form">
            <div class="login-bcg">
                
            </div>
            <div class="login">
                <form action="./" method="post">
                    <div title><h1>Conection</h1></div>
                    <%
                        if(isSubmission){
                            %>
                            <div class="boxAlert bad">Nom d'utilisateur ou mot de passe incorrect !</div>
                            <script>
                                setTimeout(function(){
                                    document.querySelector(".boxAlert").style.display="none";
                                }, 5000);
                            </script>
                            <%
                        }
                    %>
                    <input type="text" placeholder=" Pseudo" name="pseudo"><br><br>
                    <input type="password" placeholder="Mot de passe" name="pass"><br><br>
                    <div class="button">
                        <input type="submit" value="register" name="submit" id="submit" />
                    </div>
                </form>
           </div>   
    </div>
       
    </body>
</html>
<style>
    
  *{
    font-family: Poppins, sans-serif;
    box-sizing: border-box;
    list-style: none;
    margin: 0;
    padding: 0;
    text-decoration: none;
}
form{
    margin-top: -80px;
}
.title_view{
    text-transform: uppercase;
}
.body_form{
    background-color: white;
    display: flex;
    height: 100vh;
}
.login{
    -webkit-box-shadow: 1px 1px 7px 3px #e0e0e0; 
    box-shadow: 1px 1px 7px 3px #e0e0e0;
}
.login-bcg{
    background: url("./media/code.jpg");
    background-size: 82% auto;
    width: 60%;
}
.login{
    background: #fff;
    width: 32%;
    justify-content: center;
    display: flex;
    align-items: center;
    margin: 40px 30px;
    border-radius: 3px
}
input{
    border-radius: 10px;
    padding: 5px;
    border: 1px solid #efefef;
    width: 220px;
    margin: 7px 0;
}
.button  #submit{
    height: 35px;
    width: 223px;
    padding: 8px;
    background: orange;
    color: #192d34;
    border: none;
    border-radius: 10px;
    font-size: 18px;
    font-weight: bold;

}
</style>