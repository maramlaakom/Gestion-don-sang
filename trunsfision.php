
<?php
require_once "connexion.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);


// Récupérer les dons avec statut 'VALIDE'
try {
    $dons_stmt = $pdo->query("
        SELECT id_don
        FROM dons
        WHERE statut = 'UTILISÉ'
    ");
    $dons = $dons_stmt->fetchAll(PDO::FETCH_ASSOC);
} catch(PDOException $e) {
    die("Erreur lors de la récupération des dons : " . $e->getMessage());
}

// Traitement du formulaire
if(isset($_POST['submit'])){
    $id_don = htmlspecialchars($_POST['id_don']);
    $hopital = htmlspecialchars($_POST['hopital']);
    $date_transfusion = date('Y-m-d');

    // Enregistrer la transfusion
    $stmt = $pdo->prepare("
        INSERT INTO transfusions (id_don, hopital_recepteur, date_transfusion)
        VALUES (?, ?, ?)
    ");
    $stmt->execute([$id_don, $hopital, $date_transfusion]);

    // Mettre à jour le statut du don
    $pdo->prepare("UPDATE dons SET statut='UTILISÉ' WHERE id_don=?")->execute([$id_don]);

    echo "<p style='color:green;'>Transfusion enregistrée et don utilisé !</p>";
}
?>

<form method="POST">
    <label for="id_don">Don :</label>
    <select name="id_don" required>
        <option value="">-- Choisir un don --</option>
        <?php foreach($dons as $d){ ?>
            <option value="<?= htmlspecialchars($d['id_don']) ?>">
                Don n°<?= htmlspecialchars($d['id_don']) ?>
            </option>
        <?php } ?>
    </select><br><br>

    <label for="hopital">Hôpital :</label>
    <input type="text" name="hopital" required><br><br>

    <input type="submit" name="submit" value="Transfuser">
</form>

<form method="POST">
    <label for="id_don">Don :</label>
    <select name="id_don">
        <?php foreach($dons as $d){ ?>
            <option value="<?= $d['id_don'] ?>">Don n°<?= $d['id_don'] ?> </option>
        <?php } ?>
    </select><br>

      <label for="hopital">Hospital :</label>
    <input type="text" name="hopital"><br>

    <input type="submit" name="submit" value="Transfuser">
</form>
