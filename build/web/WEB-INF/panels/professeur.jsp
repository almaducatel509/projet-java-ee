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
    String modifier = (String) request.getParameter("modifier");
    db = (PDO)session.getAttribute("pdo");
    HashMap<String, Object> prof = null;
 
    if(modifier != null){
        db.prepare("SELECT * FROM professeur WHERE idProfesseur = :pIdProfesseur");
        db.params("pIdProfesseur", modifier );
        if(db.execute()){
            if(db.hasNext()){
                prof = db.fetch();
                response.sendRedirect("panel?res=professeur");
            }
        }
         System.out.println("modifier: "+modifier);
    }
    ArrayList<String> postes = Utils.Poste();

%>
<div class="popup_entry <%= prof !=null ? "active" : "" %>">
    <div class="entry">
        <div class="popup_head">
            <h3>Enregistrer un professeur</h3>
        </div>
        <div class="popup_body">  
            <form action="./panel?res=professeur" method="post" class="form_entry">
                <input type="hidden" name="profId" value="<%= prof == null ? "" : prof.get("idProfesseur") %>">
                
                <div class="avatar" style="background-image : url(<%= prof != null ? "./media/"+prof.get("profil") : "" %>)">
                    <input class="file" type="file" value="" >
                    <i class="las la-camera"></i>
                </div>
                <input class="avatar_input" type="hidden" name="avatar" value="" />
                 <%
//                    String filename = "";
                    ArrayList<String> listF = Utils.filiere();
                       int i = 0;
                %>
                <div class="input">
                    <label for="firstname" class="labels"> Entrez le prenom</label>
                    <input type="text" name="firstname" placeholder="prenom" value="<%= prof == null ? "" : prof.get("prenom") %>">
                </div>
                <div class="input">
                    <label for="lastname" class="labels"> Nom</label>
                    <input type="text" name="lastname" placeholder="nom" value="<%= prof == null ? "" : prof.get("nom") %>">
                </div>
                <div class="input" >
                   <div class="btn_radio">
                       <input type="radio"  name="sexe" value="femme" <%= prof == null ? "" : prof.get("sexe").equals("femme") ? "checked" : "" %>>
                        <label for="femal">Femme</label><br>
                        <input type="radio" name="sexe" value="homme"  <%= prof == null ? "" : prof.get("sexe").equals("homme") ? "checked" : "" %>>
                        <label for="mal">Homme</label><br>
                    </div>
                </div>
                <div class="input" >
                    <label for="adresse" class="labels"> Entrez l'adresse</label>
                    <input type="text" name="adresse" placeholder="adresse" value="<%= prof == null ? "" : prof.get("adresse") %>" >  
                </div>

                <div class="input">
                    <label for="tel"  class="labels">Numero de telephone</label>
                    <input type="text" name="tel" placeholder="---- ----" value="<%= prof == null ? "+509 " : prof.get("telephone") %>">
                </div>
                <div class="input" >
                   <div class="btn_radio">
                        <input type="radio" id="marie" name="statutM" value="marie" <%= prof == null ? "" : prof.get("statut_matrimonial").equals("Marie") ? "checked" : "" %>>
                        <label for="marie">Marie(e)</label><br>
                        <input type="radio" id="Celibatair" name="statutM" value="Celibatair" <%= prof == null ? "" : prof.get("statut_matrimonial").equals("Celibatair") ? "checked" : "" %>>
                        <label for="Celibatair">Celibatair(e)</label><br>
                        <input type="radio" id="uLibre" name="statutM" value="Union libre" <%= prof == null ? "" : prof.get("statut_matrimonial").equals("Union libre") ? "checked" : "" %>>
                        <label for="uLibre">Union libre</label><br>
                    </div>
                </div>
                <div class="input" class="labels">
                    <label for="lieuNaissance" class="labels">Lieu de naissance</label>
                    <input type="text" name="lieuNaissance" placeholder="lieu de naissance" value="<%= prof == null ? "" : prof.get("lieu_naissance") %>">
                </div>
                <div class="input">
                    <label for="datenaissance" class="labels">Date de naissance</label>
                    <input type="date" name="dateNaissance" placeholder="lieu de naissance" value="<%= prof == null ? "" : prof.get("date_naissance") %>">
                </div> 
                <div class="input">
                    <label for="niveau"  class="labels"> Niveau</label>
                    <input type="text" name="niveau" value="<%= prof == null ? "" : prof.get("niveau") %>">
                </div>
                <div class="input">
                    <label for="filiere" class="labels">Entrez la filiere</label>
                    <select name="filiere">
                         <%
                         for(String filiere : listF) {
                         %>
                         <option value="<%= filiere %>"  <%= prof == null ? "" : prof.get("filiere_affecte").equals(filiere) ? "selected" : "" %> > <%= filiere %> </option>
                         <%
                             i++;
                         }
                         %>
                    </select>    
                </div>
                <div class="input" >
                    <label for="salaire"  class="labels">Votre salaire</label>
                    <input type="text" name="salaire"  value="<%= prof == null ? "" : prof.get("salaire") %>">
                </div>
                <div class="input">
                    <label for="filiere" class="labels">Entrez le poste</label>
                    <select name="filiere">
                        <option>Poste</option>
                         <%
                         for(String poste : postes) {
                         %>
                         <option value="<%= poste%>"> <%= poste%> </option>
                         <%
                         }
                         %>
                    </select>
                </div>
                <div class="input">
                    <label for="email"  class="labels">Votre email</label>
                    <input type="text" name="email" placeholder="email" value="<%= prof == null ? "" : prof.get("email") %>">
                </div>
                <div class="input">
                    <label for="cinNif"  class="labels">CIN/NIF</label>
                    <input type="text" name="cinNif" placeholder="cin/nif" value="<%= prof == null ? "" : prof.get("nif_cin") %>">
                </div> 
                <div class="textarea_style input">
                    <label for="memo" class="labels">Memo</label>
                    <textarea name="memo" class ="memo" rows="4" cols="37" maxlength="100" minlength="3" placeholder="Commentaire..."></textarea>
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
           <h2 class=" title_view">Pofesseurs</h2>
       </div>
       <div class="AcadY">
           <span class="iconY las  la-calendar-check"></span>
           <span class="ActualY">2020-2021</span>
       </div>
    </div>

    <% 
        db = (PDO)session.getAttribute("pdo");
        String idP = (String)request.getParameter("profId");
        String codeProfesseur = (String)request.getParameter("codeProfesseur");
        String nom =(String)request.getParameter("lastname");
        String prenom = (String)request.getParameter("firstname");
        String sexe =(String)request.getParameter("sexe");
        String adresse = (String)request.getParameter("adresse");
        String lieu_naissance = (String)request.getParameter("lieuNaissance");
        String date_naissance = (String)request.getParameter("dateNaissance");
        String telephone = (String)request.getParameter("tel");
        String email = (String)request.getParameter("email");
        String statutMatrimonial = (String)request.getParameter("statutM");
        String niveau = (String)request.getParameter("niveau");
        String filiere = (String)request.getParameter("filiere");
        String nif_cin = (String)request.getParameter("cinNif");
        String poste = (String)request.getParameter("poste");
        String salaire = (String)request.getParameter("salaire");
        String memo = (String)request.getParameter("memo");
        String avatar = (String)request.getParameter("avatar");
        String idProfesseur= (String) request.getParameter("trash");

        System.out.println("codeProfesseur :"+codeProfesseur);
        System.out.println("nom: "+nom);
        System.out.println("prenom: "+prenom);
        System.out.println("sexe: "+sexe);
        System.out.println("adresse: "+adresse);
        System.out.println("tel: "+telephone);
        System.out.println("filiere: "+filiere);
        System.out.println("niveau: "+niveau);
        System.out.println("lieu de naissance: "+lieu_naissance);
        System.out.println("memo: "+memo);
        System.out.println("date de naiss: "+date_naissance);
        System.out.println("eamil: "+email);
        System.out.println("statut Matrimo: "+statutMatrimonial);
        System.out.println("email: "+poste);
        System.out.println("salaire: "+salaire);
        System.out.println("avatar: "+avatar);

        if(idProfesseur !=null){
            db.prepare("DELETE FROM professeur WHERE idProfesseur =:pIdProfesseur");
            db.params("pIdProfesseur", idProfesseur);

            if(db.execute()){
                %>
                <div class="boxAlert">Supression reussi!</div>
                <script>
                    setTimeout(function(){
                        document.querySelector(".boxAlert").style.display="none";
                    }, 2000);
                </script>
                <%
            }
        }

        if(nom != null && prenom !=null && sexe !=null && adresse !=null && statutMatrimonial !=null &&
            lieu_naissance !=null && date_naissance !=null && telephone !=null && filiere !=null &&
            email !=null && salaire !=null && poste !=null && niveau !=null && codeProfesseur!=null && nif_cin !=null ){
             if(avatar != null){
                avatar = Utils.uploadFile(avatar, this.getServletContext().getRealPath("/")+"media/", null);
            }
            int ID = 0;
            codeProfesseur = Utils.getCode(nom, prenom);
            if(idP == null || idP.length() == 0){
                db.prepare("INSERT INTO professeur (codeProfesseur, nom, prenom, profil, sexe, adresse, telephone, statut_matrimonial, lieu_naissance, date_naissance, niveau, filiere_affecte, poste, salaire, email, nif_cin, memo) "
                    + "VALUES (:pCodeProfesseur, :pNom, :pPrenom, :pProfil, :pSexe, :pAdresse, :pTel, :pStatut, :pLieuNaissance, :pDateNaissance, :pNiveau, :pFiliere, :pPoste,  :pSalaire, :pEmail, :pNifCin, :pMemo)");
            }
            else{
                db.prepare("Update professeur set nom=:pNom, prenom=:pPrenom, "+(avatar != null && avatar.length() > 0 ? "profil=:pProfil," : "")+" sexe=:pSexe, adresse=:pAdresse, telephone=:pTel, statut_matrimonial=:pStatut, "
                    + "lieu_naissance=:pLieuNaissance, date_naissance=:pDateNaissance, niveau=:pNiveau, filiere_affecte=:pFiliere, poste=:pPoste, salaire=:pSalaire, email=:pEmail, nif_cin=:pNifCin, memo=:pMemo"
                    + " WHERE idProfesseur = :pIdp");
                 ID = Integer.parseInt(idP);

            }
            System.out.println("Idp : "+idP+" / "+ID);
            db.params("pNom", nom);
            db.params("pCodeProfesseur", codeProfesseur);
            db.params("pPrenom", prenom);
            db.params("pSexe", sexe);
            db.params("pAdresse",adresse);
            db.params("pLieuNaissance", lieu_naissance);
            db.params("pDateNaissance", date_naissance);
            db.params("pTel", telephone);
            db.params("pEmail", email);
            db.params("pPoste", poste);
            db.params("pSalaire", salaire);
            db.params("pNiveau", niveau);
            db.params("pFiliere", filiere);
            db.params("pNifCin", nif_cin);
            db.params("pStatut", statutMatrimonial);
            db.params("pProfil", avatar);
            db.params("pMemo", memo);
            db.params("pIdp", ID);

            if(db.execute()){
                %>
                <div class="boxAlert"><%= idP.length() > 0 ? "Modification reussi! " : "Enregistrement reussi!" %></div>
                <script>
                    setTimeout(function(){
                        document.querySelector(".boxAlert").style.display="none";
                    }, 2000);
                </script>
                <%
            }
        }        
    %>

    <div class="lastBolock">
        <div class="see">
            <div class="button_head">
                <button class="print" onclick="printForm('form1')">
                    <span class="print_icon las  la-print"></span>
                    <span class="print_span"></span> 
                </button>
                <button class="print">
                    <span class="print_icon las  la-plus-square"></span>
                    <span class="add_span"></span> 
                </button>
            </div>
            <div class="rang">
                <form action="./panel?res=professeur" class="rang_entry" method="POST">
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
                            <option></option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="forme_print" id="form1">                  
                <div class="colums">
                    <div class="column">Code</div>
                    <div class="column">Profil</div>
                    <div class="column">Nom</div>
                    <div class="column">Prenom</div>
                    <div class="column">Sexe</div>
                    <div class="column">Statut</div>
                    <div class="column">operation</div>
                </div>
                <div class="allrows">
                   <% 
                       db = DBConnect.getCon();
                       db.prepare("SELECT * from professeur");
                       if(db.execute()){
                          HashMap<String, Object> data;
                          while(db.hasNext()){
                              data = db.fetch();

                   %>
                    <div class="rows">
                        <div class="row"><%= data.get("codeProfesseur") %></div>
                        <div class="row profil_img" style="justify-content: center; background-image: url(./media/<%= data.get("profil") == null ? "Dr_dada.png" : data.get("profil") %>);"></div>
                        <div class="row"><%= data.get("nom") %></div>
                        <div class="row"><%= data.get("prenom") %></div>
                        <div class="row"><%= data.get("sexe") %></div>
                        <div class="row"><%= data.get("etat") %></div>   
                        <div class="row icons_operation"> 
                            <form method="post" action="./panel?res=professeur">
                                <input type="hidden" name="modifier" value="<%= data.get("idProfesseur") %>">
                                <button type="submit" class=" pen las  la-pencil-alt"></button>
                            </form>
                            <form method="post" action="./panel?res=professeur">
                                <input type="hidden" name="trash" value="<%= data.get("idProfesseur") %>">
                                <button class=" trash las la-trash-alt" type="submit"></button>
                            </form>
                                <i class="las la-angle-down"></i>
                        </div>
                        <div class="row-info">
                            <div class="row Iprofil_img" style="justify-content: center; background-image: url(./media/<%= data.get("profil") == null ? "Dr_dada.png" : data.get("profil") %>);"></div>
                            <div>
                                <div class="list_info">
                                    <div class="info code"> 
                                        <span class="span_info">Code:</span>
                                        <span><%= data.get("codeProfesseur") %></span></div>
                                    <div class="info nom">
                                        <span class="span_info">Nom:</span>
                                        <span class="point nom"><%= data.get("nom") %></span>
                                    </div>
                                    <div class="info">
                                        <span class="span_info">Prenom:</span>
                                        <span class="point prenom"><%= data.get("prenom") %></span>
                                    </div>
                                    <div class="info sexe">
                                        <span class="span_info">Sexe:</span>
                                        <span><%= data.get("sexe") %></span>
                                    </div>
                                    <div class="info adresse">
                                        <span class="span_info">Adresse:</span>
                                        <span><%= data.get("adresse") %></span>
                                    </div>
                                    <div class="info telephone">
                                        <span class="span_info">Tel:</span>
                                        <span><%= data.get("telephone") %></span>
                                    </div>
                                    <div class="info statut_matrimonial">
                                        <span class="span_info">Statut Matrimonial:</span>
                                        <span><%= data.get("statut_matrimonial") %></span>
                                    </div>
                                    <div class="info lieu_naissance">
                                        <span class="span_info">Lieu Naissance:</span>
                                        <span><%= data.get("lieu_naissance") %></span>
                                    </div>
                                    <div class="info date_naissance">
                                        <span class="span_info">Date de naissance:</span>
                                        <span><%= data.get("date_naissance") %></span>
                                    </div>
                                    <div class="info niveau">
                                        <span class="span_info point">Niveau:</span>
                                        <span><%= data.get("niveau") %></span>
                                    </div>
                                    <div class="info">
                                        <span class="span_info/">Filiere afectee:</span>
                                        <span class="point filiere"><%= data.get("filiere_affecte") %></span>
                                     </div>
                                    <div class="info poste">
                                        <span class="span_info">Poste:</span>
                                        <span ><%= data.get("poste") %></span>
                                    </div>
                                    <div class="info salaire">
                                        <span class="span_info">Salaire:</span>
                                        <span><%= data.get("salaire") %></span>
                                    </div>
                                    <div class="info email">
                                        <span class="span_info">Email:</span>
                                        <span><%= data.get("email") %></span>
                                    </div>
                                    <div class="info cin_nif">
                                        <span class="span_info">CIN/NIF: </span>
                                        <span><%= data.get("cin_nif") %></span>
                                    </div>
                                    <div class="info memo">
                                        <span class="span_info">Memo: </span>
                                        <span><%= data.get("memo") %></span>
                                    </div>
                                    <div class="etats">
                                        <form method="post" action="">
                                            <input type="hidden" name="etat" value="">
                                            <div class="buttons">
                                                <button type="submit" class="etat-btn">A</button>
                                                <button class="etat-btn" type="submit">I</button>
                                                <button class="etat-btn" type="submit"> E</button>
                                                <button class="etat-btn" type="submit">C</button>
                                                <button class="etat-btn active" type="submit">M</button>
                                            </div>
                                        </form>
                                    </div>
                                </div> 

                            </div>
                        </div>
                    </div>
                        <% }

                        }
                    %>

                </div>
            </div>
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
        width: 30%;
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
        background: #ffffff;
        width: 40vw !important;
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
    .btn_radio{
        display: inline-flex;
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
    #quit{
        background: rgb(179, 179, 179);
        color: #131D28;
    }
    #quit:hover, .closed:hover, .opened:hover{
        background: rgb(255, 166, 0);
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
        position: relative
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
        position: relative;
        display: inline-block;
        height: 60vh;
        width: 100%;
        overflow-y: auto;
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