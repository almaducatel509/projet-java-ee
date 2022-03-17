<%@page import="dbutils.Utils"%>
<%@page import="java.io.InputStream"%>
<%@page import="dbutils.Utils.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="dbutils.PDO"%>
<%@page import="dbutils.DBConnect"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.Enumeration" %>


<%! 
   PDO db;
%>
<% 
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    String modifier = (String) request.getParameter("modifier");
    db = (PDO)session.getAttribute("pdo");
    HashMap<String, Object> not = null;
    if(modifier != null){
        db.prepare("SELECT n.*, c.niveau, c.session, c.filiere  FROM notes n, cours c WHERE id_note = :pId_note and n.codeCours = c.codeCours");
        db.params("pId_note", modifier);
        if(db.execute()){
            if(db.hasNext()){
                not = db.fetch();
            }
        }
    }
%>
 <%
    ArrayList<String[]> myList = Utils.selectEtudiant();
    ArrayList<String> listF = Utils.filiere();
    ArrayList<String[]> listE = Utils.selectEtudiant();
    ArrayList<String[]> listC = Utils.selectCours();
    ArrayList<String[]> listP = Utils.selectProfesseur();
    int i =0;
%>
<script>
    var dataset = {
        cours : {},
        etudiant: {},
        professeur: {}
    };
    <% 
    int k = 0;
    for(String[] cours : listC){ %>
        dataset.cours[<%= k %>] = {
            "id" : "<%= cours[0] %>",
            "nom" : "<%= cours[1] %>",
            "coefficient" : <%= cours[2] %>,
            "niveau" : "<%= cours[3] %>",
            "filiere" : "<%= cours[5] %>",
            "session" : <%= cours[4] %>,
            "titulaire" : "<%= cours[6] %>",
            "suppleant" : <%= cours[7] == null ? null : "\""+cours[7]+"\"" %>
        }
    <% 
        k++;
    } 
        k = 0;
    %>
    <% 
    for(String[] prof : listP){ %>
        dataset.professeur[<%= k %>] = {
            "id" : "<%= prof[0] %>",
            "nom" : "<%= prof[1] %>",
            "filiere" : "<%= prof[2] %>"
        }
    <% 
        k++;
    } 
    k = 0;
    %>
    <% 
    for(String[] etu : listE){ %>
        dataset.etudiant[<%= k %>] = {
            "id" : "<%= etu[0] %>",
            "nom" : "<%= etu[1] %>",
            "code" : "<%= etu[2] %>",
            "filiere" : "<%= etu[3] %>",
            "niveau" : "<%= etu[4] %>"
        }
    <% 
        k++;
    } 
    k = 0;
    %>
</script>
<div class="popup_entry <%= not !=null ? "active" : "" %>">

    <div class="entry">
        <div class="popup_head"> 
            <h3> Enregistrer une note</h3>
        </div>
        <div class="popup_body">
            <form action="./panel?res=note" method="POST" class="form_entry">
                <input type="hidden" name="noteId" value=" <%= not == null ? "" : not.get("id_note")%>" >
                <div class="input">
                    <select name="filiere" <%= not == null ? "" : "disabled" %>>
                        <option>Choisissez la filiere</option>
                        <%for(String filiere : listF) {%>
                        <option value="<%= filiere %>" <%= not == null || !not.get("filiere").toString().equals(filiere) ? "" : "selected" %>> <%= filiere %> </option>
                       <%
                           i++;
                       }%>
                    </select>
                </div>
                <div class="input">
                    <select name="niveau" <%= not == null ? "" : "disabled" %>>
                        <option>Choisissez le niveau</option>
                        <% if(not != null){ 
                            for(String niveau : Utils.getNiveau(not.get("filiere").toString())){
                        %>
                        <option value="<%= niveau %>" <%= not == null || !not.get("niveau").toString().equals(niveau) ? "" : "selected" %> ><%= niveau %></option>
                        <%  }
                           }
                        %>
                    </select>
                </div>
                <div class="input">
                    <select name="session" <%= not == null ? "" : "disabled" %> >
                        <option value="">Selectionnez la session</option>
                        <option value="1" <%= not == null || !not.get("session").toString().equals("1") ? "" : "selected" %> >Session 1</option>
                        <option value="2" <%= not == null || !not.get("session").toString().equals("2") ? "" : "selected" %> >Session 2</option>
                    </select>
                </div>
                <div class="input">
                    <select name="etudiant" <%= not == null ? "" : "disabled" %>>
                        <option>Choisissez l'etudiant</option>
                        <% if(not != null){ 
                            for(String[] etu : Utils.selectEtudiant(not.get("filiere").toString(), not.get("niveau").toString())){
                        %>
                        <option value="<%= etu[0] %>" <%= not == null || !not.get("idEtudiant").toString().equals(etu[0]) ? "" : "selected" %> ><%= etu[1] %></option>
                        <%  }
                           }
                        %>
                    </select>
                </div>
                <div class="input">
                    <select name="cours" <%= not == null ? "" : "disabled" %>>
                        <option>Selectionnez le cours</option>
                        <% if(not != null){ 
                            for(String[] cours : Utils.selectCours(not.get("filiere").toString(), not.get("niveau").toString())){
                        %>
                        <option value="<%= cours[0] %>" <%= not == null || !not.get("codeCours").toString().equals(cours[0]) ? "" : "selected" %> ><%= cours[1] %></option>
                        <%  }
                           }
                        %>
                    </select>
                </div>
                <div class="input">
                    <input type="text" placeholder="Entrez la note sur 100" name="noteSur100" value="<%= not == null  ? "" : not.get("noteSur100") %>">
                </div>
            </form>
        </div>
        <div class="button_input">
            <button type="submit" value="submit" name="submit" id="submit" style="cursor:pointer;">Ajouter</button>
            <button type="reset" value="clear" name="clear" id="quit" class="quit" style="cursor:pointer;">Quiter</button>
        </div>              
    </div>
</div>

<div class="main-content">
    
    <div class="head">
       <div class="view">
           <span class=" las  la-chalkboard-teacher"></span>
           <h2 class=" title_view">Notes</h2>
       </div>
       <div class="AcadY">
           <span class="iconY las  la-calendar-check"></span>
           <span class="ActualY">2020-2021</span>
       </div>
    </div>
    <%
        db = (PDO) session.getAttribute("pdo");
        String idN = (String)request.getParameter("noteId");
        String cours = (String) request.getParameter("cours");
        String etudiant = (String) request.getParameter("etudiant");
        String noteSur100 = (String) request.getParameter("noteSur100");
        String idNote = (String) request.getParameter("trash");
        
        System.out.println("idN: "+idN);
        System.out.println("Trash: "+idNote);
        System.out.println("cours: "+cours);
        System.out.println("etudiant: "+etudiant);
        System.out.println("noteSur100: "+noteSur100);
        System.out.println("not: "+not);
        
        if(idNote !=null){
            db.prepare("DELETE FROM notes WHERE id_note =:id");
            db.params("id",idNote);
           
             if(db.execute()){
            %>
            <div class="boxAlert">Suppression reussi!</div>
            <script>
                setTimeout(function(){
                    document.querySelector(".boxAlert").style.display="none";
                }, 5000);
            </script>
            <%
            }
        }
    
    if(cours !=null && etudiant !=null && noteSur100 !=null){
        if(idN ==null || idN.length() ==0 ){
            db.prepare("INSERT INTO notes (idEtudiant, codeCours, noteSur100, annee_academique)"
            + "VALUES (:pIdEtudiant, :pCodeCours, :pNoteSur100, (select id from annee_academique where etat = 'O'))");
        }else{
            db.prepare("UPDATE notes SET noteSur100=:pNoteSur100 WHERE id_note =:pIdN  ");
        }

        db.params("pIdEtudiant", etudiant);
        db.params("pCodeCours", cours);
        db.params("pNoteSur100", noteSur100);
        db.params("pIdN", idN);
        
         if(db.execute()){
            %>
            <div class="boxAlert"><%= idN.length() > 0 ? "Modification reussi! " : "Enregistrement reussi!" %></div>
            <script>
                setTimeout(function(){
                    document.querySelector(".boxAlert").style.display="none";
                }, 5000);
            </script>
            <%
        }
        
    }
    %>
    <div class="lastBolock">
        <div class="see" id="notes">
            <div class="button_head">
                <button class="print">
                    <span class="print_icon las  la-plus-square"></span>
                    <span class="add_span"></span> 
                </button>
<!--                <div class="print">
                     <form method="post" action="./panel?res=bultin">
                        <input type="hidden" name="trash">
                        <button class="print_icon las la-arrow-right" type="submit"></button>
                    </form>
                    <span class="arrow1"></span> 
                </div>
                     
                <div class="print">
                     <form method="post" action="./panel?res=palmares">
                         <input type="hidden" name="trash">
                        <button class="print_icon las la-arrow-right" type="submit"></button>
                     </form>
                    <span class="arrow2"></span>
                </div>
                -->
            </div>
            <div class="rang">
                <form action="./panel?res=professeur" class="rang_entry" method="POST">
                    <div class="rang_input">
                        <select name="filiere">
                            <option value="">Choisissez la filiere</option>
                            <%for(String filiere : listF) {%>
                           <option value="<%= filiere %>"> <%= filiere %> </option>
                           <%
                               i++;
                              }
                           %>
                        </select>
                    </div>
                    <div class="rang_input">
                        <select name="niveau">
                            <option value="">Choisissez le niveau</option>
                            <option></option>
                        </select>
                    </div>
                    <div class="rang_input">
                        <select name="session">
                            <option value="">Selectioner la session</option>
                            <option value="1">Session 1</option>
                            <option value="2">Session 2</option>
                        </select>
                    </div>
                </form>
            </div>
        <div class="colums">
            <div class="column">Code</div>
            <div class="column">Nom</div>
            <div class="column">Prenom</div>
            <div class="column">Filiere</div>
            <div class="column">Matiere</div>
            <div class="column">Note total</div>
            <div class="column">operation</div>
        </div> 
        <div class="allrows">
            <% 
                db.prepare("SELECT n.*, e.codeEtudiant, e.nomEtudiant, e.prenomEtudiant, c.nomCours, c.niveau, c.session, c.filiere "
                        + "FROM notes n, etudiant e, cours c WHERE e.idEtudiant = n.idEtudiant AND c.codeCours = n.codeCours");
                if(db.execute()){
                   HashMap<String, Object> data;
                   double note = 0;
                   while(db.hasNext()){
                       data = db.fetch();
            %>

            <div class="rows">           
               <div class="row"><%= data.get("codeEtudiant") %></div>
               <div class="row point nom"><%= data.get("nomEtudiant") %></div>
               <div class="row point prenom"><%= data.get("prenomEtudiant") %></div>
               <div class="row point filiere"><%= data.get("filiere") %></div>
               <div class="row"><%= data.get("nomCours") %></div>
               <div class="row"><%= data.get("noteSur100") %></div>
               <div class="row point niveau" style="display: none"><%= data.get("niveau") %></div>
               <div class="row point session" style="display: none"><%= data.get("session") %></div>

              <div class="row icons_operation"> 
                    <form method="post" action="./panel?res=note">
                        <input type="hidden" name="modifier" value="<%= data.get("id_note") %>">
                        <button type="submit" class=" pen las  la-pencil-alt"></button>
                    </form>
                    <form method="post" action="./panel?res=note">
                        <input type="hidden" name="trash" value="<%= data.get("id_note") %>">
                        <button class=" trash las la-trash-alt" type="submit"></button>
                    </form>
               </div>
            </div>
                    <%
                    }
                 }
             %>
            </div>

        </div>
        
    </div>
</div>
<!-- <script>
    function afficherInscription() {
        document.getElementById('notes').style.display = 'block';
        document.getElementById('bultin').style.display = 'none';
        document.getElementById('palmares').style.display = 'none';
    }
//    m vle f yn lien onclick qui mete sam clicke a block e 2 lot yo none
</script>-->
<style>
/*    #notes{
        display: block;
    }*/
    #bultin{
        display: none;
    }
    #palmares{
        display: none;
    }
    .rang_input{
      padding: 10px;
      color: #ffffff;
      font-size: 14px;
    }
    .rang{
        width: 100%;
    }
    .rang form{
        display: flex;
    }
   .rang_input select{ 
        background-color: #ffffff;
        height: 30px;
        width: 200px;
        border: 0;
        outline: none;
        padding: 0 8px;
        border-radius: 10px;
   }
    .print{
        width: 50px;
        display: inline-flex;
        background-color: #f09103;
        margin: 0.3em .5em .4em 0;
        border: none;
        height: 40px;
        justify-content: left;
        border-radius: 5px;
        overflow: hidden;
        box-shadow: 0 10px 10px rgba(0, 0, 0, 0.1);
        transition-property: width;
        transition-duration: .2s;
    }
    .print:hover{
        width: 250px;
        display: inline-flex;
        background-color: var(--main);
        margin: 0.3em .5em .4em 0;
        border: none;
        height: 40px;
        align-items: center;
        border-radius: 5px;
        overflow: hidden;
        box-shadow: 0 10px 10px rgba(0, 0, 0, 0.1);

    }

    .print_span::before{
        content: "";
        font-size: 1.5em;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #ffffff;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    } 
    .button_head .add_span::before{
        content: "";
        font-size: 1.5em;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #ffffff;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    }
    .button_head .add_span::after{
        content: "Ajouter";
        font-size: 1.5em;
        font-weight: 600;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #ffffff;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    }
    .arrow1::before{
        content: "";
        font-size: 1.5em;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #ffffff;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    }
    .arrow2::before{
        content: "";
        font-size: 1.5em;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #ffffff;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    }
    .arrow1::after{
        content: "Palmares";
        text-transform: uppercase;
        font-size: 1.5em;
        font-weight: 600;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #efefef;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    } 
    .arrow2::after{
        content: "Bultin";
        text-transform: uppercase;
        font-size: 1.5em;
        font-weight: 600;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #efefef;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    } 
   
    .print_icon{
        border: none;
        background: #f09103;
        line-height: 40px;
        height: 40px;
        font-size: 2em;
        padding: 0 11px;
        color: #efefef;
    }
   /* entry */
   .avatar{
       height: 100px;
       width: 100px;
       border: 1px solid #000;
       border-radius: 50px; 
       display: flex;
       align-items: center;
       justify-content: center;
       font-size: 2em;
       color: #131D28;
       background-size: auto 100%;
       background-position: center;
       background-repeat: no-repeat;
    }
    .file{
        display: none;
    }
     .popup_entry{
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        position: absolute;
        z-index: -1;
        opacity: 0;
        transition-duration: .2s;
        transition-property: z-index, opacity;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 5px;
    }

    .popup_entry.active{
        z-index: 3;
        opacity: 1;
    }
    .popup_head{
        background: #fff;
        height: 60px;
        width: 100%;
        display: inline-block;
        text-transform: uppercase;

    }
    .popup_head h3{
        align-items: center;
        padding: 10px 30px;
        margin: .1em 8.5em;
        color: #131D28;
        font-size: 17px;
        font-weight: 600;
    }
    .popup_body{
        background: #ffffff;
        display: inline-block;
        overflow: hidden;
        overflow-y: auto;
        padding: .5em 3em;
    }
    .entry{
        display: flex;
        flex-direction: column;
        background: #ffffff;
        height: 90vh;
        overflow: hidden;
        z-index: 3;
    }

    .entry .input {
        width: 49%;
        border: 0;
        margin: .2em 0;
        outline: none;
        padding: .4em;
        padding-bottom: 0;
        border-radius: 1em;
        display: inline-flex;
        flex-direction: column;
    }

    .entry input:focus {
        border-bottom-color: #ffa600c5;
    }
    .entry label{
        width: 100%;
        display: inline-block;
        color: #161616;
        font-size: .8em;
    }
    .labels{
        font-size: 14px;
    }
    .entry input, select, textarea{
        padding: .5em;
        border: 0;
        background-color: inherit;
        border-bottom: 1px solid orange;
    }
    textarea{
        margin: 5px;
        resize: none;
        outline: none;
    }
    .textarea_style{
        margin: 5px;
        width: auto;
        height: auto;
        font-size: 14px;

    }
    textarea::-webkit-scrollbar{
        width: 3px;
    }
    textarea::-webkit-scrollbar-track{
        -webkit-box-shadow:inset 0 0 10px #bddae0 ;
        box-shadow: 0px 0px 5px 1px rgba(0,0,0,0.03);
    }
    textarea::-webkit-scrollbar-thumb{
        background-color: #0bbff9;
    }
    .entry button{
        margin: .6em;
        outline: none;
        width: 30%;
        color:#131D28;
        border: none;
        border-radius: 5px;
        height: 30px;
        box-shadow: 0px 0px 5px 1px rgba(0,0,0,0.04);
        font-weight: 600;
    }
   
    .button_input #submit, #quit{
        background: #9f9f9f;
    }
    .button_input{
        margin-left: 9.5em;
    }
    .trash{
        font-size: 1.5em;
        color: #ff3c00;
    }
    .trash:hover{
        background: rgb(255, 197, 189);
        padding: 2px;
        justify-content: center;
        border: solid .9px #ff3c00;
        width: 30px;
        height:30px;
        border-radius: 50%;
    }
    .pen{
        color: #0084ff;
        font-size: 1.5em;
    }
    .pen:hover{
        background: #e1eeffcb;
        padding: 2px;
        justify-content: center;
        border: solid .9px #0084ff;
        width: 30px;
        height:30px;
        border-radius: 50%;
    }

    .head{
        display: flex;
        justify-content: space-between;
        padding: 2rem 1rem;
        align-items: center;
    }
    .AcadY{
        font-size: 2rem;
        color: #efefef;
        align-items: center;
        display: flex;
    }
    .iconY{
        font-size: 1.5em;
    }
    .button__head {
        display: inline-flex;
        border-radius: 5px;
    }
    .button__head div{
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: .5em 2em;
        font-weight: 600;
    }
    .btn_radio{
        display: inline-flex;
    }
    .head{
        display: flex;
        justify-content: space-between;
        padding: 2rem 1rem;
        align-items: center;
    }
    .view{
        display: flex;
        color: #efefef;
        align-items: center;
    }
    .view {
        font-size: 4em;
    }
    .title_view{
        font-weight: 500;
        font-size: 2.3rem;
    }
   
    .lastBolock{
        display: inline-block;
        width: 100%;
    }
    .see{
        display: flex;
        flex-direction: column;
        width: 100%;
        margin-top: 2em;
        height: auto;
        overflow: hidden;
        overflow-x: auto;

    }
    .colums{ 
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        color: #131D28;
        background: #efefef;
        font-weight: bold;
        justify-content: space-between;
        font-size: 1em;
        padding: 1em;
    }

    .allrows{
        display: inline-block;
        height: 60vh;
        width: 100%;
        overflow-y: auto;
    }
    .rows{
        width: 100%;
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        justify-content: space-between;
        align-items: center;
        color: #efefef;
        font-size: 1em;
        padding: 1em;
        border: solid .1em #efefef;
        position: relative
    }
    .rows .row-info{
        position: absolute;
        top: 100%;
        left: 0;
        width: 100%;
        height: 350px;
        background-color: #efefef;
        z-index: 2;
        display: none;
    }

    .row-info .span_info{
        color: #131D28;
        font-size: 18px;
        font-weight: 600;
    }
    .rows:hover{
        background: #efefef;
        color: #131D28;
        -moz-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03) ;
        -webkit-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03);
        box-shadow: 0px 0px 5px 1px rgba(0,0,0,0.03);
        border: solid 3px #131D28;
    }
    .rows.active .row-info{
        display: grid;
        color: #131D28;
        grid-template-columns: 20% 80%;
        justify-content: space-between;
        border: solid 1.5px #131D28;
        padding: 20px;
        overflow-y: auto;
    }
    .row-info .list_info{
        display: grid;
        grid-template-columns: repeat(3, 1fr) ;
        justify-content: space-between;
        padding: 20px;
        border: none;
    }
    .rows:focus{
        background: #efefef;
        color: #131D28;
        -moz-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03) ;
        -webkit-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03);
        box-shadow: 0px 0px 5px 1px rgba(0,0,0,0.03);
        border: solid 3px #131D28;
    }
    .rows:focus .row-info{
        display: inline-block;
        -moz-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03) ;
        -webkit-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03);
        box-shadow: 0px 0px 5px 1px rgba(255, 192, 192, 0.3);
        border: solid 1.5px #131D28;
    }

    .rows:focus{
        -moz-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03) ;
        -webkit-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03);
        box-shadow: 0px 0px 5px 1px rgba(255, 192, 192, 0.03);
        border: solid 1.5px #131D28;
    }
    .profil_img{
        height: 45px;
        width: 45px;
        background-size: cover;
        background-repeat: no-repeat;
        border-radius: 50%;
        border: 3px solid #efefef;
        position: relative;   
        background-size: auto 100%;
        background-repeat: no-repeat;
        background-position: center; 
    }
    .Iprofil_img{
        height: 150px;
        width: 150px;
        background-size: auto 100%;
        background-repeat: no-repeat;
        background-position: center;
        top: 0;
        border: 4px solid #efefef;
        border-radius: 50%;
    }

</style>
<script src="./js/search.js"></script>
<script src="./js/note.js"></script>