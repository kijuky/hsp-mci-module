#module "mymci"
/**
 * mymci の初期化
 */
#deffunc mci_init int
	mref i, 0
	max_mci_file = i
	dim mci_file, max_mci_file, 2
	return

/**
 * mymci に音楽を登録( sndload に相当)
 */
#deffunc mci_load str, int, int
	mref s, 32
	mref i, 1
	mref m, 2
	if i >= max_mci_file {
		dialog "扱える id 数を超えています\nid = " + i, 1, "mci_open 命令"
		end
	}
	exist s : if strsize == -1 {
		dialog "ファイルが開けません。\n file_name = " + s, 1, "mci_open 命令"
		end
	}
	mci "open " + s + " alias " + i
	mci_file.i = 1 : mci_file.i.1 = m
	return

/**
 * mymci の音楽を停止
 */
#deffunc mci_stop int
	mref i, 0
	mci "stop " + i
	return

/**
 * mymci の音楽を停止（ sndoff に相当）
 */
#deffunc mci_stop_all
	repeat max_mci_file
		if mci_file.cnt : mci_stop cnt
	loop
	return

/**
 * id のメディアを削除する
 */
#deffunc mci_destroy int
	mref i, 0
	mci "close " + i
	mci_file.i = 0
	return

/**
 * 全てのメディアを削除する
 */
#deffunc mci_destroy_all
	repeat max_mci_file
		if mci_file.cnt : mci_destroy cnt
	loop
	return

/**
 * id の音楽が再生終了していたら 1 を返す
 * 但し、無限ループ再生のものは無視する
 */
#deffunc mci_chk_stop int
	mref i, 0
	mref s, 64
	mci "status " + i + " length"   : l = stat
	mci "status " + i + " position" : p = stat
	s = (l == p) && (mci_file.i.1 != 1)
	return

/**
 * id の音楽が再生中なら 1 を返す
 */
#deffunc mci_chk_play int
	mref i, 0
	mref s, 64
	mci_chk_stop i
	s = s + 1 \ 2
	return

/**
 * mymci の音楽全てが再生終了していたら 1 を返す
 * 但し、無限ループ再生のものは無視する
 */
#deffunc mci_chk_stop_all
	repeat max_mci_file
		if mci_file.cnt && (mci_file.cnt.1 != 1) : mci_chk_stop cnt : if stat : break
	loop
	return

/**
 * id の音楽を再生（ snd に相当）
 */
#deffunc mci_play int
	mref i, 0
	if mci_file.i == 0 {
		dialog "その id にはメディアがロードされていません\nid = " + i, 1, "mci_play 命令"
		end
	}
	mci "play " + i + " from 0 "
	if mci_file.i.1 == 2 {
*@:		mci_chk_play i
		await 15
		if stat : goto @b
	}
	return

/**
 * id の音楽が無限ループ再生だったら、無限ループ再生する
 */
#deffunc mci_chk_infinity int
	mref i, 0
	if mci_file.i == 0 {
		dialog "その id にはメディアがロードされていません\nid = " + i, 1, "mci_chk_infinity 命令"
		end
	}
	if mci_file.i.1 == 1 : mci_chk_stop i : if stat : mci_play i
	return

/**
 * mymci の音楽全てが無限ループ再生だったら、無限ループ再生する
 */
#deffunc mci_chk_infinity_all
	repeat max_mci_file
		if mci_file.cnt : mci_chk_infinity cnt
	loop
	return


/**
 * mymci の開放
 */
#deffunc mci_close onexit
	mci_destroy_all
	return

#global