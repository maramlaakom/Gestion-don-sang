<?php
require "connexion.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// --- 1) Récupérer les dons EN STOCK ---
$dons = $pdo->query("SELECT id_don FROM dons WHERE statut='EN STOCK'")
            ->fetchAll(PDO::FETCH_ASSOC);

// --- 2) Traitement du formulaire ---
if(isset($_POST['valider'])){
    
    $id_don = $_POST['id_don'];
    $est_conforme = (int)$_POST['est_conforme'];

    // Vérifier si test déjà enregistré
    $check = $pdo->prepare("SELECT id_test FROM tests_don WHERE id_don=?");
    $check->execute([$id_don]);

    if($check->rowCount() > 0){
        // Mise à jour
        $stmt = $pdo->prepare("UPDATE tests_don SET est_conforme=? WHERE id_don=?");
        $stmt->execute([$est_conforme, $id_don]);
        echo "<p style='color:blue;'>Test mis à jour pour ce don.</p>";
    } else {
        // Insertion
        $stmt = $pdo->prepare("INSERT INTO tests_don (id_don, est_conforme) VALUES (?, ?)");
        $stmt->execute([$id_don, $est_conforme]);
        echo "<p style='color:green;'>Test enregistré pour ce don.</p>";
    }

    // Mise à jour statut du don
    $statut = $est_conforme ? 'UTILISÉ' : 'REJETÉ';
    $stmt2 = $pdo->prepare("UPDATE dons SET statut=? WHERE id_don=?");
    $stmt2->execute([$statut, $id_don]);
}
?>

<!-- --- Formulaire --- -->
<form method="POST">

    <label>Don :</label>
    <select name="id_don" required>
        <option value="">-- Choisir un don --</option>

        <?php foreach($dons as $d){ ?>
            <option value="<?= $d['id_don'] ?>">Don n°<?= $d['id_don'] ?></option>
        <?php } ?>

    </select><br><br>

    <label>Résultat test :</label>
    <input type="text" name="resultat"><br><br>

    <label>Conforme :</label>
    <select name="est_conforme">
        <option value="1">Oui</option>
        <option value="0">Non</option>
    </select><br><br>

    <input type="submit" name="valider" value="Valider Test">
</form>


