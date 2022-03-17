<%-- 
    Document   : panel
    Created on : Nov 4, 2021, 5:41:44 PM
    Author     : ALMA  la-sign-out-alt
--%>

<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dbutils.*,javax.servlet.http.HttpSession" %>
<%
  HashMap<String, Object> user = (HashMap<String, Object>)session.getAttribute("user");
  String signout = (String) request.getParameter("signout");
  if(signout != null){
      session.setAttribute("user", null);
      user = null;
  }
  if(user == null){
      response.sendRedirect("./");
      return;
  }
%>
<%! 
    PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
    String[] icon = {"las la-home","las la-calendar-day","las  la-user-graduate", "las la-chalkboard-teacher", "las la-pencil-ruler","las la-tasks", "las  la-users", "las la-book"};
    String[] label ={ "Dashboard", "Annee academique", "Etudiant","Professeur","Cours","Horaire","Utilisateur","Note"};
    String[] link = {"home", "academique","etudiant", "professeur","cours","horaire","utilisateur","note"};
    String[] ressource = {"dashboard.jsp","academique.jsp","etudiants.jsp","professeur.jsp","cours.jsp","horaire.jsp","utilisateur.jsp","notes.jsp"};
    String menu(String res, HashMap<String, Object> user){
        String html="";
        for(int i = 0, j = link.length; i < j; i++){
            if(i == 0 || user.get("privilege").toString().contains(label[i])){
                html += " <li><a href=\"panel?res="+link[i]+"\" class="+(res.equals(link[i]) ? "active" : "")+" >\n" +
    "                    <span class=\""+icon[i]+"\"></span>\n" +
    "                    <span>"+label[i]+"</span>\n" +
    "                </a></li>";
            }
        }
        return html;
    }
    
     String title(String res){
        String title ="ERROR 404";
        for(int i = 0, j = link.length; i < j; i++){
            if(res.equals(link[i])){
                title = label[i];
                break;
            }
        }
        return title;
    }
     
    String view(String res, HashMap<String, Object> user){
        String view = "error.jsp";
        for(int i = 0, j = link.length; i < j; i++){
            if(res.equals(link[i]) && (i == 0 || user.get("privilege").toString().contains(label[i]))){
                view = ressource[i];
                break;
            }
        }
        return "panels/"+view;
    }
%>
<%
   String res = request.getParameter("res"); 
    res = res == null ? link[0] : res;
    session.setAttribute("pdo", db);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="./fonts.css" rel="stylesheet" type="text/css"/>
    <link href="./css/ionicons/css/ionicons.css" rel="stylesheet" type="text/css"/>
    <link href="./css/line-awesome-1.3.0/css/line-awesome.css" rel="stylesheet" type="text/css"/>
    <link href="style.css" rel="stylesheet" type="text/css"/>
    <script src="./js/zepto.js" type="text/javascript"></script>
    
    <title><%= title(res) %></title>
</head>
<body> 
   
    <div class="app">
        <div class="sidebar">
            <div class="brand">
                <span class="las la-code"></span>
                <h3>SmartHead</h3>
                <span class="las la-code"></span>
            </div>
            <div class="sidemenu">
                <div class="side-user">
                    <div class="side-img" style=
                    "background-image: url(images.png);"></div>
                    <div class="user">
                        <small><%= user.get("prenomUser")+" "+user.get("nomUser") %></small>
                        <p><%= user.get("poste") %></p>
                    </div>
                </div>

                <ul>
                    <%= menu(res, user) %>
                </ul>
            </div>
        </div>
        <div class="main-content">
            <header>
                <label for="" class="menu-toggle"> 
                    <span class=" las la-bars"></span>
                </label>
                <div class="search-content">
                    <div class="search">
                        <input type="text" onekeyup="mySearch()"  placeholder="Recherchez...">
                        <icon class="ion-ios-search-strong"></icon>
   
                    </div>
                </div>
                <div class="content-las">
                    <form action="./panel" method="post">
                        <input type="hidden" name="signout">
                        <button type="submit" class="las  la-sign-out-alt" id="signout"></button>
                    </form>
                </div>
            </header>
            <main>
                <% pageContext.include(view(res, user)); %>
            </main>
        </div>
    </div>
            
    <script src="./js/graph.js" type="text/javascript"></script>
    <script src="./js/chart.min.js" type="text/javascript"></script>
    <script src="./js/scroll.js" type="text/javascript"></script>
    <script src="./js/popup.js"></script>
    <script src="./js/print.js"></script>

    
</body>
</html>