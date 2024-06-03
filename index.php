<?php

session_start();
// koneksi
require 'functions.php';

// cek user login

if (!isset($_SESSION['admin'])) {
    header("Location: login.php");
    exit;
}
$item = 1;

?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard</title>

    <link rel="stylesheet" href="assets/css/main/app.css?<?php echo time(); ?>" />
    <link rel="stylesheet" href="assets/css/main/app-dark.css?<?php echo time(); ?>" />
    <link rel="shortcut icon" href="assets/images/logo/favicon.svg?<?php echo time(); ?>" type="image/x-icon" />
    <link rel="shortcut icon" href="assets/images/logo/favicon.png?<?php echo time(); ?>" type="image/png" />

    <link rel="stylesheet" href="assets/css/shared/iconly.css?<?php echo time(); ?>" />
</head>

<body>
    <div id="app">
        <?php require 'sidebar.php';?>
        <div id="main">
            <header class="mb-3">
                <a href="#" class="burger-btn d-block d-xl-none">
                    <i class="bi bi-justify fs-3"></i>
                </a>
            </header>

            <?php 
            $ambil=$db->query("SELECT * FROM transaksi ");
            $tot = 0;
            while($pecah = $ambil->fetch_assoc()) {
            $tot = $tot + 1; 
            }?>
            <?php 
            $ambils=$db->query("SELECT * FROM barang WHERE stok_barang<20 ");
            $stoks = 0;
            while($pecah = $ambils->fetch_assoc()) {
            $stoks = $stoks + 1; 
            }?>

            <div class="page-heading">
                <h3>Profile Penjualan</h3>
            </div>
            <div class="page-content">
                <section class="row">
                    <div class="col-12 col-lg-9">
                        <div class="row">
                            <div class="col-6 col-lg-3 col-md-6">
                                <div class="card">
                                    <div class="card-body px-4 py-4-5">
                                        <a href="tabeltransaksi.php">
                                            <div class="row">
                                                <div
                                                    class="col-md-4 col-lg-12 col-xl-12 col-xxl-5 d-flex justify-content-start">
                                                    <div class="stats-icon red mb-2">
                                                        <i class="iconly-boldBookmark"></i>
                                                    </div>
                                                </div>
                                                <div class="col-md-8 col-lg-12 col-xl-12 col-xxl-7">
                                                    <h6 class="text-muted font-semibold">Totals</h6>
                                                    <h6 class="font-extrabold mb-0"><?php echo $tot?></h6>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3 col-md-6">
                                <div class="card">
                                    <div class="card-body px-4 py-4-5">
                                        <a href="barangrestok.php">
                                            <div class="row">

                                                <div
                                                    class="col-md-4 col-lg-12 col-xl-12 col-xxl-5 d-flex  justify-content-start">
                                                    <div class="stats-icon purple mb-2">
                                                        <i class="iconly-boldShow"></i>
                                                    </div>
                                                </div>
                                                <div class="col-md-8 col-lg-12 col-xl-12 col-xxl-7">
                                                    <h6 class="text-muted font-semibold">Restock</h6>
                                                    <h6 class="font-extrabold mb-0"><?php echo $stoks?></h6>
                                                </div>

                                            </div>
                                        </a>
                                    </div>
                                </div>

                            </div>
                            <!-- <div class="col-12 pt-10 col-lg-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h4>Sales Comparison</h4>
                                    </div>
                                    <div class="card-body">
                                        <div id="chart-visitors-profile"></div>
                                    </div>
                                </div>
                            </div> -->

                        </div>
                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h4>Penjualan Barang</h4>
                                    </div>
                                    <div class="card-body">
                                        <div id="chart-profile-visit"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-12 col-xl-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h4>Count Sales</h4>
                                        </h4>
                                    </div>
                                    <div class="card-body">
                                        <?php $ambilkaryawan=$db->query("SELECT * FROM karyawan");
                                        $cek = 0;
                                        while($pecahkaryawan = $ambilkaryawan->fetch_assoc()) {?>


                                        <div class="row">
                                            <div class="col-6">
                                                <div class="d-flex align-items-center">
                                                    <svg class="bi text-primary" width="32" height="32" fill="blue"
                                                        style="width: 10px">
                                                        <use
                                                            xlink:href="assets/images/bootstrap-icons.svg#circle-fill" />
                                                    </svg>
                                                    <h5 class="mb-0 ms-3"><?php echo $pecahkaryawan['username'];
                                                    $cek++; ?></h5>
                                                </div>
                                            </div>
                                            <?php $id=$pecahkaryawan['id'];
                                            $ambilpenjualan=$db->query("SELECT * FROM transaksi where id_karyawan=$id");
                                            $total = 0;
                                            while($pecahpenjualan = $ambilpenjualan->fetch_assoc()) {
                                            $total++;
                                             }?>
                                            <div class="col-6">
                                                <h5 class="mb-0"><?= $total ?></h5>
                                            </div>
                                            <?php if($cek==1){?>
                                            <div class="col-12">
                                                <div id="chart-europe"></div>
                                            </div>
                                            <?php }
                                            else if($cek==2){?>
                                            <div class="col-12">
                                                <div id="chart-america"></div>
                                            </div>
                                            <?php }
                                            else
                                            {?>
                                            <div class="col-12">
                                                <div id="chart-indonesia"></div>
                                            </div>
                                            <?php  }?>

                                        </div>
                                        <?php }?>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 col-xl-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h4>Daftar Karyawan</h4>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-hover table-lg">
                                                <!-- <thead>
                                                    <tr>
                                                        <th>Name</th>
                                                    </tr>
                                                </thead> -->
                                                <tbody>

                                                    <?php $ambilkaryawans=$db->query("SELECT * FROM karyawan");
                                                $id = 0;
                                                while($pecahkaryawans = $ambilkaryawans->fetch_assoc()) {
                                                        $id++; ?>

                                                    <tr>
                                                        <td class="col-3">
                                                            <div class="d-flex align-items-center">
                                                                <div class="avatar avatar-md">
                                                                    <img src="assets/images/logo/favicon.png" />
                                                                </div>
                                                                <p class="font-bold ms-3 mb-0">
                                                                    <?= $pecahkaryawans['username']?></p>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <?php }?>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 pt-10 col-lg-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h4>Sales Comparison</h4>
                                    </div>
                                    <div class="card-body">
                                        <div id="chart-visitors-profile"></div>
                                    </div>
                                </div>
                            </div>
                            
                        </div>
                    </div>
                </section>
            </div>

            <footer>
                <div class="footer clearfix mb-0 text-muted">
                    <div class="float-end">
                        <p>2024 &copy; Radityo Ar Rasyid</p>
                    </div>
                </div>
            </footer>
        </div>
    </div>
    <script src="assets/js/bootstrap.js"></script>
    <script src="assets/js/app.js"></script>

    <!-- Need: Apexcharts -->
    <script src="assets/extensions/apexcharts/apexcharts.min.js"></script>
    <?php require'assets/js/pages/dashboard.php';?>
</body>

</html>