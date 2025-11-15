<?php
require "connexion.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Liste des dons EN STOCK
$dons = $pdo->query("
    SELECT d.id_don, dn.id_donneur
    FROM dons d 
    JOIN donneurs dn ON d.id_donneur=dn.id_donneur 
    WHERE d.statut='EN STOCK'
")->fetchAll();

if(isset($_POST['valider'])){
    $id_don =  htmlspecialchars($_POST['id_don']);
    $resultat = htmlspecialchars($_POST['resultat']);
    $est_conforme = htmlspecialchars((int)$_POST['est_conforme']); // 1 = oui, 0 = non

    // Vérifier si un test existe déjà pour ce don
    $check = $pdo->prepare("SELECT * FROM tests_don WHERE id_don=?");
    $check->execute([$id_don]);
    
    if($check->rowCount() > 0){
        // Mettre à jour le test existant
        $pdo->prepare("UPDATE tests_don SET est_conforme=? WHERE id_don=?")
            ->execute([$est_conforme, $id_don]);
        echo "Test mis à jour pour ce don.";
    } else {
        // Enregistrer un nouveau test
        $pdo->prepare("INSERT INTO tests_don (id_don, est_conforme) VALUES (?, ?)")
            ->execute([$id_don, $est_conforme]);
        echo "Test enregistré pour ce don.";
    }

    // Mettre à jour le statut du don
   // Mettre à jour le statut du don
$statut = $est_conforme ? 'UTILISÉ' : 'REJETÉ';
$stmt = $pdo->prepare("UPDATE dons SET statut=? WHERE id_don=?");
$stmt->execute([$statut, $id_don]);
}
?>
<form method="POST">
    <label for="id_don">Don :</label>
    <select name="id_don" required>
        <option value="">-- Choisir un don --</option>
        <?php foreach($dons as $d){ ?>
            <option value="<?=htmlspecialchars($d['id_don']) ?>">
                Don n°<?= htmlspecialchars($d['id_don']) ?> 
            </option>
        <?php } ?>
    </select><br>

    <label for="resultat">Résultat test :</label>
    <input type="text" name="resultat"><br>

    <label for="est_conforme">Conforme :</label>
    <select name="est_conforme">
        <option value="1">Oui</option>
        <option value="0">Non</option>
    </select><br>

     <input type="submit" name="valider" value="Valider Test">

</form>


