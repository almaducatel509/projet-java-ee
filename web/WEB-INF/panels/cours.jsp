<%@page import="java.io.InputStream"%>
<%@page import="dbutils.Utils"%>
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
    ArrayList<String> listF = Utils.filiere();
    ArrayList<String[]> listC = Utils.selectCours();
    ArrayList<String[]> listP = Utils.selectProfesseur();
    int i = 0;
    
%>
<% 
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    String modifier = (String) request.getParameter("modifier");
    db = (PDO)session.getAttribute("pdo");
    HashMap<String, Object> crs = null;
    if(modifier != null){
        db.prepare("SELECT * FROM cours WHERE codeCours = :pCodeCours");
        db.params("pCodeCours", modifier );
        if(db.execute()){
            if(db.hasNext()){
                crs = db.fetch();
            }
        }
    }
%>
<div class="popup_entry <%= crs!=null ? " active" : "" %>">
    <div class="entry">
        <div class="popup_head">
            <h3>Enregistrer un cours</h3>
        </div>
        <div class="popup_body">  
            <form action="./panel?res=cours" method="post" class="form_entry">
                <input type="hidden" name="cId" value="<%= crs == null ? "" : crs.get("codeCours") %>">
                <div class="input">
                    <label for="nomCours" class="labels">Entrez la matiere</label>
                    <input type="text" name="nomCours" placeholder="Matiere" value="<%= crs == null ? "" : crs.get("nomCours") %>" />
                </div>
                <div class="input">
                    <label for="filiere" class="labels">Entrez la filiere</label>
                    <select name="filiere">
                        <%for(String filiere : listF) {%>
                        <option value="<%= filiere %>" <%= crs == null ? "" : crs.get("filiere").equals(filiere) ? "selected" : "" %>> <%= filiere %> </option>
                        <%
                            i++;
                        }%>
                    </select>     
                </div>
                <div class="input">
                    <label for="niveau" class="labels">Entrez le niveau</label>
                    <select name="niveau">
                        <option></option>
                        <% if(crs != null){
                            for(String grade : Utils.getNiveau(crs.get("filiere").toString())){
                        
                        %>
                        <option value="<%= grade %>" <%= grade.equals(crs.get("niveau")) ? "selected" : "" %>><%= grade %></option>
                        <%
                            }
                        }
                        %>
                    </select>
                </div>
                    <div class="input">
                    <label for="professeur_titulaire" class="labels">Entrez le professeur titulaire</label>
                    <select name="professeur_titulaire" tag="<%= crs == null ? "" : crs.get("professeur_titulaire") %>">
                        <option></option>
                        <% for(String[] p : listP){ %>
                        <option value="<%= p[0] %>"  <%= crs == null ? "" : crs.get("professeur_titulaire").toString().equals(p[0]) ? "selected" : "" %> ><%= p[1] %></option>
                        <% } %>
                    </select>
                </div>
                    <div class="input">
                    <label for="professeur_supleant" class="labels">Entrez le professeur suppleant</label>
                    <select name="professeur_supleant">
                        <option></option>
                        <% for(String[] p : listP){ %>
                        <option value="<%= p[0] %>" <%= crs == null ? "" : crs.get("professeur_supleant") != null && crs.get("professeur_supleant").toString().equals(p[0]) ? "selected" : "" %>><%= p[1] %></option>
                        <% } %>
                    </select>
                </div>
                <div class="input">
                    <label for="coefficient" class="labels">Entrez le coefficient</label>
                    <input type="text" name="coefficient" placeholder="Coeficient" value="<%= crs == null ? "" : crs.get("coefficient") %>" />
                </div>
                <div class="input">
                    <label for="session" class="labels">choisissez la session</label>
                    <select name="session">
                        <option value="1" <%= crs == null ? "" : crs.get("session").equals("1") ? "selected" : "" %> >session 1</option>
                        <option value="2" <%= crs == null ? "" : crs.get("session").equals("2") ? "selected" : "" %>>session 2</option>
                    </select>
                </div> 
<!--                <div class="input">
                    <label for="jour" class="labels">Choisissez le jour</label>
                    <select name="jour">
                        <option value="Lundi">Lundi</option>
                        <option value="Mardi">Mardi</option>
                        <option value="Mecredi">Mercredi</option>
                        <option value="Jeudi">Jeudi</option>
                        <option value="Vendredi">Vendredi</option>
                    </select>
                </div>
                 <div class="input">
                    <label for="heure_debut" class="labels">Heure debut cours</label>
                    <input type="time" name="heure_debut" value="<%= crs == null ? "" : crs.get("heure_debut") %>" >
                </div>
                <div class="input">
                     <label for="heure_fin" class="labels">Heure fin cours</label>
                     <input type="time" name="heure_fin" value="<%= crs == null ? "" : crs.get("heure_fin") %>" >
                 </div>-->
            </form>
        </div>
        <div class="button_input">
            <button type="submit" value="Submit" name="submit" id="submit">Ajouter</button>
            <button type="reset" value="Clear" name="clear" id="quit" class="quit">Quiter</button>
        </div>
    </div>   
</div>

<% 
    db = (PDO)session.getAttribute("pdo");
    String idC = (String)request.getParameter("cId");
    String nomCours =(String)request.getParameter("nomCours");
    String filiere =(String)request.getParameter("filiere");
    String niveau = (String)request.getParameter("niveau");
    String coefficient =(String)request.getParameter("coefficient");
    String session0 =(String)request.getParameter("session");
    String jour =(String)request.getParameter("jour");
    String heure_debut = (String)request.getParameter("heure_debut");
    String heure_fin =(String)request.getParameter("heure_fin");
    String professeur_titulaire = (String)request.getParameter("professeur_titulaire");
    String professeur_supleant = (String)request.getParameter("professeur_supleant");
    String codeCours = (String) request.getParameter("trash");


    System.out.println("matiere :"+nomCours);
    System.out.println("filiere :"+filiere);
    System.out.println("niveau :"+niveau);
    System.out.println("coefficient : "+coefficient);
    System.out.println("session : "+session0);
    System.out.println("jour : "+jour);
    System.out.println("heure_debut : "+heure_debut);
    System.out.println("heure_fin : "+heure_fin);
    System.out.println("professeur_titulaire : "+professeur_titulaire);
    System.out.println("professeur_supleant : "+professeur_supleant);
    
    if(codeCours !=null){
        db.prepare("DELETE FROM cours WHERE codeCours = :pCodeCours");
        db.params("pCodeCours", codeCours);
        
        if(db.execute()){
            %>
            <div class="boxAlert">Supression reussi!</div>
            <script>
                setTimeout(function(){
                    document.querySelector(".boxAlert").style.display="none";
                }, 5000);
            </script>
            <%
        }
    }
    
    if( nomCours !=null && filiere !=null && niveau !=null && coefficient !=null && professeur_titulaire !=null && session0 !=null){
        if(idC == null || idC.length() == 0){
             db.prepare("INSERT INTO cours( nomCours, niveau, session, coefficient, professeur_titulaire, professeur_supleant, filiere)"
                + " VALUES (:pNomCours,:pNiveau, :pSession, :pCoefficient, :pProfesseur_titulaire, :pprofesseur_supleant, :pFiliere)");
        
        }else{
            db.prepare("UPDATE cours SET nomCours =:pNomCours, niveau =:pNiveau, session=:pSession,"
            + "coefficient=:pCoefficient, professeur_titulaire=:pProfesseur_titulaire, professeur_supleant=:pprofesseur_supleant, filiere=:pFiliere WHERE codeCours=:pidC");
        }
        System.out.println("pidC: "+idC);
        db.params("pNomCours", nomCours);
        db.params("pFiliere", filiere);
        db.params("pNiveau", niveau);
        db.params("pCoefficient", coefficient);
        db.params("pSession", session0);
        db.params("pProfesseur_titulaire", professeur_titulaire);
        db.params("pprofesseur_supleant", professeur_supleant.length() > 0 ? professeur_supleant : null );
        db.params("pidC", idC);
        System.out.println("pidc: "+idC);
      
        if(db.execute()){
            %>
            <div class="boxAlert"><%= idC.length() > 0 ? "Modification reussi! " : "Enregistrement reussi!" %></div>
            <script>
                setTimeout(function(){
                    document.querySelector(".boxAlert").style.display="none";
                }, 5000);
            </script>
            <%
        }
    }
%>


<div class="head">
    <div class="view">
        <span class=" las  la-chalkboard-teacher"></span>
        <h2 class=" title_view">Cours</h2>
    </div>
    <div class="AcadY">
        <span class="iconY las  la-calendar-check"></span>
        <span class="ActualY">2020-2021</span>
    </div>

</div>
 
<div class="lastBolock">
    <div class="see">
        <div class="button_head">
            <button class="print">
                <span class="print_icon las  la-plus-square"></span>
                <span class="add_span"></span> 
            </button>
        </div>
        <div class="rang">
            <form action="rang_entry" method="POST">
                <div class="rang_input">
                    <select name="filiere">
                        <option value="">Selectioner le filiere</option>
                         <%for(String f : listF) {%>
                        <option value="<%= f %>"> <%= f %> </option>
                        <%
                            i++;
                        }%>
                    </select>
                </div>
                <div class="rang_input">
                    <select name="niveau">
                        <option value="">Selectioner le niveau</option>
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
             <div class="column">Matiere</div>
             <div class="column">Filière</div>
             <div class="column">Niveau</div>
             <div class="column">Professeur titulair</div>
             <div class="column"> Professeur supleant </div>
             <div class="column"> Etat</div>
             <div class="column">operation</div>
        </div>
          
        <div class="allrows">

        <% 
            db = DBConnect.getCon();
            db.prepare("SELECT *, (select concat(prenom, ' ', nom) from professeur where idProfesseur = professeur_titulaire) as titulaire, (select concat(prenom, ' ', nom) from professeur where idProfesseur = professeur_supleant) as suppleant FROM cours");    
            if(db.execute()){
               HashMap<String, Object> data;
               while(db.hasNext()){
                   data = db.fetch();

        %>
        
        <div class="rows">            
            <div class="row"><%= data.get("codeCours") %></div>
            <div class="row point nom"><%= data.get("nomCours") %></div>
            <div class="row point filiere"><%= data.get("filiere") %></div>
            <div class="row point niveau"><%= data.get("niveau") %></div>   
            <div class="row"><%= data.get("titulaire") %></div> 
            <div class="row"><%= data.get("suppleant") %></div>
            <div class="row"><%= data.get("etat") %></div>   
            <div class="row icons_operation"> 
                <form method="post" action="./panel?res=cours">
                    <input type="hidden" name="modifier" value="<%= data.get("codeCours") %>">
                    <button type="submit" class=" pen las  la-pencil-alt"></button>
                </form>                    
                <form method="post" action="./panel?res=cours">
                    <input type="hidden" name="trash" value="<%= data.get("codeCours") %>">
                    <button href="#"class=" trash las la-trash-alt" type="submit"></button>
                </form>
            </div>
            <div class="row-info">
                <div class="list_info">
                   <div class="info code"> 
                       <span class="span_info">Code:</span>
                       <span><%= data.get("codeCours") %></span></div>
                   <div class="info nom">
                       <span class="span_info">Matiere:</span>
                       <span><%= data.get("nomCours") %></span></div>
                   <div class="info prenom">
                       <span class="span_info">Niveau:</span>
                       <span><%= data.get("niveau") %></span></div>
                   <div class="info sexe">
                       <span class="span_info">Session:</span>
                       <span class="point session"><%= data.get("session") %></span></div>
                   <div class="info adresse">
                       <span class="span_info">Adress:</span>
                       <span><%= data.get("coefficient") %></span></div>
                   <div class="info telephone">
                       <span class="span_info">Professeur titulaire:</span>
                       <span><%= data.get("professeur_titulaire") %></span>
                   </div>
                    <div class="info email">
                         <span class="span_info">Professeur suppléant:</span>
                         <span><%= data.get("professeur_supleant") %></span>
                    </div>
                   <div class="info lieu_naissance">
                       <span class="span_info">Jour cours:</span>
                       <span><%= data.get("jour_cours") %></span>
                   </div>
                   <div class="info date_naissance">
                       <span class="span_info">Heure debut: </span>
                       <span><%= data.get("heure_debut") %></span>
                   </div>
                   <div class="info personneRef">
                       <span class="span_info">Heure fin:</span>
                       <span><%= data.get("heure_fin") %></span>
                   </div>

                   <div class="info tel_ref">
                       <span class="span_info">Etat:</span>
                       <span><%= data.get("etat") %></span>
                   </div>

                   <div class="info niveau">
                       <span class="span_info"> Filiere:</span>
                       <span><%= data.get("filiere") %></span>
                   </div>
                   <div class="etats">
                        <form method="post" action="">
                            <div class="etat">
                                <input type="hidden" name="etat" value="">
                                <button type="submit" class="etat-btn">E</button>
                            </div>
                            <div>
                                <input type="hidden" name="etat" value="">
                                <button class="etat-btn" type="submit">D</button>
                            </div>
                            <div>
                                <input type="hidden" name="etat" value="">
                                <button class="etat-btn" type="submit">S</button>
                            </div>
                            <div>
                                <input type="hidden" name="etat" value="">
                                <button class="etat-btn" type="submit">N</button>
                            </div>
                            
                        </form>
                    </div>

                </div> 

            </div>       
        </div>
        <%}
            }
        %>
        </div>
    </div>
   
</div>
 <style>
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
    .horaire_span::before{
        content: "";
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
    .button_head .add_span::before{
        content: "";
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
    .button_head .add_span::after{
        content: "Ajouter";
        text-transform: uppercase;
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
    .horaire_span::after{
        content: "Horaire";
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
        border-radius: 5px;
    }

    .popup_entry.active{
        z-index: 4;
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
    .entry input, .entry select, .entry textarea{
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
        grid-template-columns: repeat(9, 1fr);
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
        grid-template-columns: repeat(9, 1fr);
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
        display: inline-flex;
        color: #131D28;
        justify-content: space-between;
        border: solid 1.5px #131D28;
        padding: 20px;
        overflow-y: auto;
    }
    .row-info .list_info{
        width: 100%;
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

</style>

<script src="./js/search.js"></script>
    