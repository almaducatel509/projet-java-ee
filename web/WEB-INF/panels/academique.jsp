<%@page import="dbutils.Utils"%>
<%@page import="dbutils.PDO"%>
<%@page import="java.util.HashMap"%>
<%@page import="dbutils.DBConnect"%>
<% 
    String modifier = (String) request.getParameter("modifier");
    String passer = (String) request.getParameter("pass");
    db = (PDO)session.getAttribute("pdo");
    HashMap<String, Object> aY = null;
    if(modifier != null){
        db.prepare("SELECT * FROM annee_academique WHERE id = :pId");
        db.params("pId", modifier );
        if(db.execute()){
            if(db.hasNext()){
                aY = db.fetch();
            }
        }
    }
    if(passer != null){
        int[] result = Utils.passerEtudiants(Integer.parseInt(passer));
        if(result[0] == result[1]){
            int next = Utils.anneeSuivant(Integer.parseInt(passer));
            if(next > 0){
                db.prepare("update annee_academique set etat = 'F' where id=:id");
                db.params("id", passer);
                db.execute();
                db.prepare("update annee_academique set etat = 'O' where id=:id");
                db.params("id", next);
                db.execute();
            }
            else{
                result[1] = 0;
            }
        }
        %>
        <div class="boxAlert <%= result[0] != result[1] || result[1] == 0 ? "bad" : "" %>">
            <%= result[0] != result[1] || result[1] == 0 ? result[1] == 0 ? "La passation n'est pas encore prête !" : (result[1] - result[0])+" étudiant(s) sur "+result[1]+" n'a/ont pas subi certaine(s) épreuve(s)" : "Passation des étuiants réussie !" %> 
        </div>
        <script>
            setTimeout(function(){
                document.querySelector(".boxAlert").style.display="none";
            }, 5000);
        </script>
        <%
    }
%>
<div class="popup_entry  <%= aY != null ? "active" : "" %>">
    <div class="entry ">
        <div class="popup_head">
            <h3>Nouvelle annee academique</h3>
        </div>
        <div class="popup_body">
            <form action="./panel?res=academique" method="post" class="form_entry">
                <input type="hidden" name="aid" value="<%= aY == null ? "" : aY.get("id") %>">
                <div class="input">
                    <label for="dateDebut" class="labels">Entrez la date du debut</label>
                    <input type="date" name="dateDebut" value="<%= aY == null ? "" : aY.get("date_debut") %>"required />
                </div>
                <div class="input">
                    <label for="dateFIN" class="labels">Entrez la date de la fin</label>
                    <input type="date" name="dateFin"  value="<%= aY == null ? "" : aY.get("date_fin") %>"required />
                </div> 
            </form>
        </div>
        <div class="button_input">
            <button type="submit" value="Submit" name="submit" id="submit">Ajouter</button>
            <button type="reset" value="Clear" name="clear" id="quit" class="quit">Quiter</button>
        </div>
    </div>
</div>

<div class="head">
    <div class="view">
        <span class=" las  la-chalkboard-teacher"></span>
        <h2 class=" title_view">Annee Academique</h2>
    </div>
    <div class="AcadY">
        <span class="iconY las  la-calendar-check"></span>
        <span class="ActualY">2020-2021</span>
    </div>
</div>
<%! 
   PDO db;
%>
<% 
    db = (PDO)session.getAttribute("pdo");
    String idA = (String)request.getParameter("aid");
    String debut = (String)request.getParameter("dateDebut");
    String fin =(String)request.getParameter("dateFin");
    
    if(debut !=null && fin != null){
        if(idA.length() == 0){
            db.prepare("INSERT INTO annee_academique (date_debut,date_fin,annee_debut,annee_fin, academicY) VALUES (:pDebut, :pFin, year(:pDebut), year(:pFin), CONCAT( year(:pDebut), '-', year(:pFin)))");
        }
        else{
            db.prepare("UPDATE annee_academique SET date_debut=:pDebut,date_fin=:pFin,annee_debut=year(:pDebut),annee_fin=year(:pFin), academicY=CONCAT( year(:pDebut), '-', year(:pFin)) WHERE id=:pidA");
        }
        db.params("pDebut", debut);
        db.params("pFin", fin);
        db.params("pidA", idA);

        if(db.execute()){
            %>
            <div class="boxAlert"><%= idA.length() == 0 ? "Enregistrement reussi!" : "Modification reussie!" %></div>
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
    <div class="see">
       
        <div class="two_part"> 
            <div class="button_head">
                <button class="print">
                    <span class="print_icon las  la-plus-square"></span>
                    <span class="add_span"></span> 
                </button>
            </div>   
            <div class="colums">
                <div class="column">Annee Debut</div>
                <div class="column">Annee Fin</div> 
                <div class="column">Date debut</div>
                <div class="column">Date fin</div>
                <div class="column">operation</div>
            </div>
            <div class="allrows">
            <% 
                db.prepare("select * from annee_academique");
                if(db.execute()){
                   System.out.println("Checked !");
                   HashMap<String, Object> data;
                   while(db.hasNext()){
                       data = db.fetch();
                       %>
                       
                        <div class="rows">
                            <div class="row"><%= data.get("annee_debut") %></div>
                            <div class="row"><%= data.get("annee_fin") %></div>
                            <div class="row"><%= data.get("date_debut") %></div>
                            <div class="row"><%= data.get("date_fin").toString() %></div>
                            <div class="row icons_operation">
                                <form method="post" action="./panel?res=academique">
                                    <input type="hidden" name="modifier" value="<%= data.get("id") %>">
                                    <button type="submit" class=" pen las  la-pencil-alt"></button>
                                </form>   &nbsp; &nbsp; &nbsp;
                                    <% if(data.get("etat").toString().equals("O")){ %>
                                <form method="post" action="./panel?res=academique">
                                    <input type="hidden" name="pass" value="<%= data.get("id") %>">
                                    <button type="submit" class="pen las la-graduation-cap"></button>
                                </form>   
                                    <% } %>
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
<script src="./js/scroll.js" type="text/javascript"></script>
<script src="./js/popup.js" type="text/javascript"></script>
<script src="./js/search.js" type="text/javascript"></script>

<style> 
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

    .button_head .add_span::before,.print_span::before, .add_filiere::before{
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
  
    .print_span::after{
        content: "Imprimer";
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
        background: #f09103;
        line-height: 40px;
        height: 40px;
        font-size: 2em;
        padding: 0 11px;
        color: #efefef;
    }
   /* entry */


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
        background:#383838a9;
        display: flex;
        align-items: center;
        justify-content: center;
        place-items: center;
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
        background: #fff;
        width: 40vw !important;
        max-height: 90vh;
        overflow: hidden;
        z-index: 3;
        height: auto;
        padding: 5px;
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
        background: #999;
        color:#131D28;
        border: none;
        border-radius: 5px;
        height: 30px;
        box-shadow: 0px 0px 5px 1px rgba(0,0,0,0.04);
        font-weight: 600;
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
    .view{
        display: flex;
        color: #efefef;
        align-items: center;
        font-size: 4em;
    }
    .title_view{
        font-weight: 500;
        font-size: 2.3rem;
    }
    .AcadY{
        display: flex;
        font-size: 2rem;
        color: #efefef;
        align-items: center;

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
    .button_etat1{
        border-right: solid .1px #131D28;
        background:#efefef;
        color: #131D28;
        border-top-left-radius: 5px;
        border-bottom-left-radius: 5px;

    }
    .button_etat2{
        background:#efefef;
        color:#131D28;
        border-right: solid .1px #131D28;
    }
    .button_etat-nth{
        background: var(--main);
        color: #131D28;
        height: 45px;
        border-top-right-radius: 5px;
        border-bottom-right-radius: 5px;
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
        grid-template-columns: repeat(5, 1fr);
        color: #131D28;
        background: #efefef;
        font-weight: bold;
        justify-content: space-between;
        font-size: 1em;
        padding: 1em;
        width: auto;
    }
    .allrows{
        display: inline-block;
        height: 60vh;
        width: 100%;
        overflow-y: auto;
    }
    .rows{
        width: auto;
        display: grid;
        grid-template-columns: repeat(5, 1fr);
        justify-content: space-between;
        align-items: center;
        color: #efefef;
        font-size: 1em;
        padding: 1em;
        border: solid .1em #efefef;
        position: relative
    }
    .rows .prof-info{
        position: absolute;
        top: 100%;
        left: 0;
        width: 40%;
        height: 200px;
        background-color: #fff;
        z-index: 2;
        display: none;
    }
    .rows:hover{
        background: #efefef;
        color: #131D28;
        -moz-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03) ;
        -webkit-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03);
        box-shadow: 0px 0px 5px 1px rgba(0,0,0,0.03);
        border: solid 3px #131D28;
    }
    .rows:hover .prof-info{
        display: inline-block;
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
    }
</style>
