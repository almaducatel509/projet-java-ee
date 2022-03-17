/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dbutils;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import javax.xml.bind.DatatypeConverter;

/**
 *
 * @author ALMA
 */
public class Utils {
    
    public static ArrayList<String[]> selectEtudiant(){
        ArrayList<String[]> listE = new ArrayList<>();
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT idEtudiant, nomEtudiant,filiere,niveau,codeEtudiant, prenomEtudiant FROM etudiant");
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                listE.add(new String[]{
                    data.get("idEtudiant").toString(), 
                    data.get("nomEtudiant")+" "+data.get("prenomEtudiant"),
                    data.get("codeEtudiant").toString(),
                    data.get("filiere").toString(),
                    data.get("niveau").toString()
                });
            }
        }
        return listE;
    }
    
    public static ArrayList<String[]> selectEtudiant(String filiere, String niveau){
         ArrayList<String[]> listE = new ArrayList<>();
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT idEtudiant, nomEtudiant,filiere,niveau,codeEtudiant, prenomEtudiant FROM etudiant where filiere=:filiere and niveau = :niveau");
        db.params("filiere", filiere);
        db.params("niveau", niveau);
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                listE.add(new String[]{
                    data.get("idEtudiant").toString(), 
                    data.get("nomEtudiant")+" "+data.get("prenomEtudiant"),
                    data.get("codeEtudiant").toString(),
                    data.get("filiere").toString(),
                    data.get("niveau").toString()
                });
            }
        }
        return listE; 
    }
    
    public static ArrayList<String[]> selectProfesseur(){
        ArrayList <String[]> listP = new ArrayList<>();
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT idProfesseur, nom, prenom, filiere_affecte FROM professeur");
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                listP.add(new String[]{
                    data.get("idProfesseur").toString(), 
                    data.get("nom")+" "+data.get("prenom"), 
                    data.get("filiere_affecte").toString()
                });
            }
        }
        return listP;
    }
    
    public static ArrayList<String[]> selectCours(){
        ArrayList <String[]> listC = new ArrayList<>();
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT nomCours,codeCours, coefficient, professeur_titulaire, professeur_supleant, niveau, session, filiere FROM cours");
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                listC.add(new String[]{ 
                    data.get("codeCours").toString(), 
                    data.get("nomCours").toString(), 
                    data.get("coefficient").toString(), 
                    data.get("niveau").toString(),
                    data.get("session").toString(),
                    data.get("filiere").toString(),
                    data.get("professeur_titulaire").toString(),
                    String.valueOf(data.get("professeur_supleant"))
                });
            }
        }
        return listC;
    }
    
    public static ArrayList<String[]> selectCours(String filiere, String niveau){
        ArrayList <String[]> listC = new ArrayList<>();
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT nomCours,codeCours, coefficient, professeur_titulaire, professeur_supleant, niveau, session, filiere FROM cours where filiere=:filiere and niveau=:niveau");
        db.params("filiere", filiere);
        db.params("niveau", niveau);
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                listC.add(new String[]{ 
                    data.get("codeCours").toString(), 
                    data.get("nomCours").toString(), 
                    data.get("coefficient").toString(), 
                    data.get("niveau").toString(),
                    data.get("session").toString(),
                    data.get("filiere").toString(),
                    data.get("professeur_titulaire").toString(),
                    String.valueOf(data.get("professeur_supleant"))
                });
            }
        }
        return listC;
    }
     public static ArrayList<String[]> selectCours(String filiere, String niveau, String session){
        ArrayList <String[]> listC = new ArrayList<>();
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT nomCours,codeCours, coefficient, professeur_titulaire, professeur_supleant, niveau, session, filiere "
                + "FROM cours where filiere=:filiere and niveau=:niveau and session = :session");
        db.params("filiere", filiere);
        db.params("niveau", niveau);
        db.params("session", session);
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                listC.add(new String[]{ 
                    data.get("codeCours").toString(), 
                    data.get("nomCours").toString(), 
                    data.get("coefficient").toString(), 
                    data.get("niveau").toString(),
                    data.get("session").toString(),
                    data.get("filiere").toString(),
                    data.get("professeur_titulaire").toString(),
                    String.valueOf(data.get("professeur_supleant"))
                });
            }
        }
        return listC;
    }
     
    public static ArrayList<String[]> selectHeure(){
        ArrayList <String[]> heure = new ArrayList<>();
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT heure_debut, heure_fin FROM cours");
        String heure_debut = null;
        db.params("heure_debut", heure_debut);
        String heure_fin = null;
        db.params("heure_fin", heure_fin);
        if(db.execute()){
            if(db.rowCount() > 0){
                HashMap<String, Object> data;
                data = db.fetch();
               heure.add(new String[]{data.get("heure_debut")+" - "+data.get("heure_fin")});
            }
        }
        return heure;
    }
    
    public static double etudiantEnToutEpreuve(String[] etudiant, int annee){
        double r = -1;
        double notes[] = new double[4];
        int effectif = 0, total = 0;
        ArrayList<String[]> Cours;
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        for(int i = 1; i <= 2; i++){
            notes[i-1] = 0;
            effectif = 0; total = 0;
            Cours = selectCours(etudiant[3],etudiant[4],i+"");
            for(String[] cours : Cours){
                db.prepare("SELECT noteSur100 FROM notes where codeCours = :idCours and idEtudiant=:idEtudiant and annee_academique=:annee");
                db.params("idCours", cours[0]);
                db.params("idEtudiant", etudiant[0]);
                db.params("annee", annee);
                if(db.execute()){
                    if(db.rowCount() > 0){
                        HashMap<String, Object> data;
                        data = db.fetch();
                        notes[i-1] += Double.parseDouble(data.get("noteSur100").toString()) * Integer.parseInt(cours[2]);
                        notes[i+1] += 100 * Integer.parseInt(cours[2]);
                        effectif++;
                        r = 0;
                    }
                }
                total++;
            }
            if(total == 0 || total != effectif){
                r = -1;
                break;
            }
        }
        return r >= 0 ? Math.round((notes[0] / notes[2] + notes[1] / notes[3]) / 2 * 10000) / 100 : r;
    }
    
    public static int[] passerEtudiants(int annee){
        int effectif = 0, total;
        double result;
        ArrayList<String[]> etudiants = selectEtudiant();
        ArrayList<String> niveau;
        ArrayList<String[]> okList = new ArrayList<String[]>();
        int indexNiveau;
        total = etudiants.size();
        for(String[] etudiant : etudiants){
            result = etudiantEnToutEpreuve(etudiant,annee);
            System.out.println("Etudiant : "+etudiant[1]+"["+etudiant[0]+"]"+" >> "+result);
            if(result >= 0){
                if(result >= 65){
                    niveau = getNiveau(etudiant[3]);
                    indexNiveau = niveau.indexOf(etudiant[4]);
                    indexNiveau = indexNiveau < 0 ? 1 : indexNiveau + 1;
                    System.out.println("Niveau : "+etudiant[4]+" >> "+niveau.get(indexNiveau)+" | "+(indexNiveau >= niveau.size()));
                    okList.add(new String[]{etudiant[0], indexNiveau >= niveau.size() ? etudiant[4] : niveau.get(indexNiveau), ""+(indexNiveau >= niveau.size())});
                }
                effectif++;
            }
        }
        if(effectif == total){
            PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
            for(String[] ok : okList){
                db.prepare("update etudiant set "+(ok[2].equals("false") ? "niveau=:val" : "etat=:val")+" where idEtudiant=:id");
                db.params("val", ok[2].equals("false") ? ok[1] : "T");
                db.params("id", ok[0]);
                db.execute();
            }
        }
        return new int[]{effectif, total};
    }
    
    public static int anneeSuivant(int actuel){
        int r = 0;
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("select y.id from annee_academique a, annee_academique y where a.id = :id and a.annee_debut = (y.annee_debut - 1) limit 1");
        db.params("id", actuel);
        db.execute();
        if(db.hasNext()){
            r = Integer.parseInt(db.fetch().get("id").toString());
        }
        else{
            db.prepare("select * from annee_academique where id = :id");
            db.params("id", actuel);
            db.execute();
            HashMap<String, Object> data = db.fetch();
            db.prepare("insert into annee_academique (date_debut,date_fin,academicY,annee_debut, annee_fin) "
                    + "values(:date_debut + INTERVAL 1 YEAR, :date_fin + INTERVAL 1 YEAR, CONCAT(:annee_debut+1, '-',:annee_fin + 1), :annee_debut+1,:annee_fin + 1)");
            db.params("date_debut", data.get("date_debut").toString());
            db.params("date_fin", data.get("date_fin").toString());
            db.params("annee_debut", Integer.parseInt(data.get("annee_debut").toString()));
            db.params("annee_fin", Integer.parseInt(data.get("annee_fin").toString()));
            db.execute();
            db.prepare("select id from annee_academique order by id desc limit 1");
            db.execute();
            r = Integer.parseInt(db.fetch().get("id").toString());
        }
        return r;
    }
    
    public static double noteEtudiant(int idEtudiant, int idCours){
        double coefficient = 0;
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT noteSur100 FROM notes where codeCours = :idCours and idEtudiant=:idEtudiant");
        db.params("idCours", idCours);
        db.params("idEtudiant", idEtudiant);
        
        if(db.execute()){
            if(db.rowCount() > 0){
                HashMap<String, Object> data;
                data = db.fetch();
                coefficient = Double.parseDouble(data.get("noteSur100").toString());
            }
        }
        return coefficient;
    }
    
    public static int selectCoefficient(int idCours){
        int coefficient = 0;
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT coefficient FROM cours WHERE codeCours=:idCours");
        db.params("idCours", idCours);
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                coefficient = Integer.parseInt(data.get("coefficient").toString());
            }
            
        }
        return coefficient;
    }
     
    public static int selectAllCours(){
        int countCours = 0;
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT count(*) AS allCourse FROM cours");
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                countCours = Integer.parseInt(data.get("allCourse").toString());
            }

        }
        return countCours;
    }
    
    public static int selectAllProfesseur(){
        int countProf = 0;
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT count(*) AS allProf FROM professeur");
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                countProf = Integer.parseInt(data.get("allProf").toString());
            }

        }
        return countProf;
    }
    
    public static int selectAllEtudiant(){
        int countEtudiant = 0;
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT count(*) AS allEtudiant FROM etudiant");
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                countEtudiant = Integer.parseInt(data.get("allEtudiant").toString());
            }
        }
        return countEtudiant;
    }
    public static int selectAllUtilisateur(){
        int countUtilisateur = 0;
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT count(*) AS allUtilisateur FROM utilisateur");
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                countUtilisateur = Integer.parseInt(data.get("allUtilisateur").toString());
            }
        }
        return countUtilisateur;
    }
    
    public static ArrayList<String[]> selectNote(){
        ArrayList <String[]> listN = new ArrayList<>();
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT n.id_note, c.coefficient, n.noteSur100, n.etat FROM notes n, cours c WHERE c.codeCours = n.codeCours");
        if(db.execute()){
            HashMap<String, Object> data;
            while (db.hasNext()){
                data = db.fetch();
                listN.add(new String[]{ data.get("id_note").toString(), data.get("noteSur100").toString()});
            }
        }
        return listN;
    }
    
    public static ArrayList<String> filiere(){
        ArrayList <String> listF = new ArrayList<>();
        listF.add("Sciences Informatiques");
        listF.add("Science Politique");
        listF.add("Science de l'Education");
        listF.add("Faculte d'Agronomie");
        listF.add("Faculte de Médecine");
        listF.add("Faculte des Sciences et de Génie");
        listF.add("Science de l'Environement");
        listF.add("Aménagement du Territoire");
        listF.add("Psychologie");
        listF.add("Psycho-Education");
        listF.add("Travail Social");
        listF.add("Sociologie");
        listF.add("Beaux-Arts");
         
        return listF;
        
    }
    
     public static ArrayList<String> Poste(){
        ArrayList <String> postes = new ArrayList<>();
        postes.add("Responsable Filiere");
        postes.add("Responsable Affaire academique");
        postes.add("President du Conseil");
        postes.add("Secraitaire General");
        postes.add("Assistant(e)");
        postes.add("Secretair(e)");
        postes.add("Professeur(e)");
        return postes;
    }
    
    public static String uploadFile(String urlData, String path, String ext){
        if(urlData.length() == 0) return null;
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
    
    public static ArrayList<String> getNiveau(String filiere){
        ArrayList<String> r = new ArrayList<>();
        r.add("EUF"); r.add("L1"); r.add("L2"); r.add("L3");
        if(filiere != null && ( filiere.equals("Faculte d'Agronomie") || filiere.equals("Faculte de Médecine") ) ){
             r.add("SPEC1");  r.add("SPEC2"); 
             if(filiere.equals("Faculte de Médecine")){
                r.add("Internat"); r.add("Social");
             }
        }
        return r;
    }
    
    public static ArrayList<String> getJours(){
        ArrayList<String> jour = new ArrayList<>();
        jour.add("Lundi");
        jour.add("Mardi");
        jour.add("Mercredi");
        jour.add("Jeudi");
        jour.add("Vendredi");
        return jour;
    }
    
    public static ArrayList<HashMap> getHoraires(){
        ArrayList<HashMap> horaires = new ArrayList<>();
        PDO db = new PDO("jdbc:mysql://localhost/chcl", "root", "");
        db.prepare("SELECT h.id, h.jour, h.heure_debut, h.heure_fin, h.type, c.nomCours, c.session, c.filiere, c.niveau, "
                + "(select concat(prenom, ' ', nom) from professeur where idProfesseur = c.professeur_titulaire) as titulaire,"
                + "(select concat(prenom, ' ', nom) from professeur where idProfesseur = c.professeur_supleant) as suppleant "
                + "from horaire h, cours c where h.idCours = c.codeCours");
        if(db.execute()){
            while(db.hasNext()){
                horaires.add(db.fetch());
            }
        }
        db.closeCursor();
        return horaires;
    }
    
    public static String setPonctuationLess(String val){
        return val.toLowerCase().replaceAll("[éèêë]", "e")
                .replaceAll("[áàâä]", "a").replaceAll("[íìîï]", "e")
                .replaceAll("[úüùû]", "e").replaceAll("[óòöô]", "e")
                .replaceAll("^ +| +$", "");
    }
    
    public static boolean isInTarget(ArrayList<String> target,String head){
        boolean r = false;
        for(String e : target){
            if(setPonctuationLess(e).equalsIgnoreCase(head)){
                r = true;
                break;
            }
        }
        return r;
    }
    
    public static String getTarget(ArrayList<String> target, String head){
        String r = null;
        for(String e : target){
            if(setPonctuationLess(e).equalsIgnoreCase(head)){
                r = e;
                break;
            }
        }
        return r;
    }
    
    public static ArrayList<String> allPrivileges(){
        ArrayList<String> r = new ArrayList<>();
        r.add("Annee academique");
        r.add("Etudiant");
        r.add("Professeur");
        r.add("Cours");
        r.add("Horaire");
        r.add("Utilisateur");
        r.add("Note");
        return r;
    }
    
    public static String getCode(String nom, String prenom){
        int total = selectAllProfesseur();
        total += selectAllEtudiant();
        total += selectAllUtilisateur();
        String code = nom.toUpperCase().charAt(0)+""+prenom.toUpperCase().charAt(0)+"-"+total;
        for(int i = 0; i < 6 - (total+"").length(); i++){
            code += "0";
        }
        return code;
    }
}
