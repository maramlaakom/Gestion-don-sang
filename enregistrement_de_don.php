
<?php
require_once "connexion.php";
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);


$donneurs = $pdo->query("SELECT id_donneur, cin FROM donneurs")->fetchAll();
$centres = $pdo->query("SELECT id_centre FROM centres_collecte")->fetchAll();

if(isset($_POST['submit'])){
    $id_donneur =htmlspecialchars( $_POST['id_donneur']);
    $id_centre = htmlspecialchars($_POST['id_centre']);

    $stmt = $pdo->prepare("INSERT INTO dons (id_donneur, id_centre, statut) VALUES (?,?, 'EN STOCK')");
    $stmt->execute([$id_donneur, $id_centre]);

    echo "Don enregistré avec succès !";
}
?>

<form method="POST">
    <label for="id_donneur">id-donneur :</label>
    <select name="id_donneur">
        
    <?php foreach($donneurs as $d){ ?>
        <option value="<?= $d['id_donneur'] ?>">
        Donneur n°<?= $d['id_donneur'] ?>
       </option>

    <?php } ?>
</select><br>



    <label for="id_centre">id-centre :</label>
    <select name="id_centre">
        <?php foreach($centres as $c){ ?>
          <option value="<?= htmlspecialchars($c['id_centre']) ?>">Centre <?= htmlspecialchars($c['id_centre']) ?></option>
</option>

        <?php } ?>
    </select><br>

    <input type="submit" name="submit" value="Enregistrer Don">
</form>
