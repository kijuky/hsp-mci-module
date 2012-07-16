#module "mymci"
/**
 * mymci �̏�����
 */
#deffunc mci_init int
	mref i, 0
	max_mci_file = i
	dim mci_file, max_mci_file, 2
	return

/**
 * mymci �ɉ��y��o�^( sndload �ɑ���)
 */
#deffunc mci_load str, int, int
	mref s, 32
	mref i, 1
	mref m, 2
	if i >= max_mci_file {
		dialog "������ id ���𒴂��Ă��܂�\nid = " + i, 1, "mci_open ����"
		end
	}
	exist s : if strsize == -1 {
		dialog "�t�@�C�����J���܂���B\n file_name = " + s, 1, "mci_open ����"
		end
	}
	mci "open " + s + " alias " + i
	mci_file.i = 1 : mci_file.i.1 = m
	return

/**
 * mymci �̉��y���~
 */
#deffunc mci_stop int
	mref i, 0
	mci "stop " + i
	return

/**
 * mymci �̉��y���~�i sndoff �ɑ����j
 */
#deffunc mci_stop_all
	repeat max_mci_file
		if mci_file.cnt : mci_stop cnt
	loop
	return

/**
 * id �̃��f�B�A���폜����
 */
#deffunc mci_destroy int
	mref i, 0
	mci "close " + i
	mci_file.i = 0
	return

/**
 * �S�Ẵ��f�B�A���폜����
 */
#deffunc mci_destroy_all
	repeat max_mci_file
		if mci_file.cnt : mci_destroy cnt
	loop
	return

/**
 * id �̉��y���Đ��I�����Ă����� 1 ��Ԃ�
 * �A���A�������[�v�Đ��̂��͖̂�������
 */
#deffunc mci_chk_stop int
	mref i, 0
	mref s, 64
	mci "status " + i + " length"   : l = stat
	mci "status " + i + " position" : p = stat
	s = (l == p) && (mci_file.i.1 != 1)
	return

/**
 * id �̉��y���Đ����Ȃ� 1 ��Ԃ�
 */
#deffunc mci_chk_play int
	mref i, 0
	mref s, 64
	mci_chk_stop i
	s = s + 1 \ 2
	return

/**
 * mymci �̉��y�S�Ă��Đ��I�����Ă����� 1 ��Ԃ�
 * �A���A�������[�v�Đ��̂��͖̂�������
 */
#deffunc mci_chk_stop_all
	repeat max_mci_file
		if mci_file.cnt && (mci_file.cnt.1 != 1) : mci_chk_stop cnt : if stat : break
	loop
	return

/**
 * id �̉��y���Đ��i snd �ɑ����j
 */
#deffunc mci_play int
	mref i, 0
	if mci_file.i == 0 {
		dialog "���� id �ɂ̓��f�B�A�����[�h����Ă��܂���\nid = " + i, 1, "mci_play ����"
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
 * id �̉��y���������[�v�Đ���������A�������[�v�Đ�����
 */
#deffunc mci_chk_infinity int
	mref i, 0
	if mci_file.i == 0 {
		dialog "���� id �ɂ̓��f�B�A�����[�h����Ă��܂���\nid = " + i, 1, "mci_chk_infinity ����"
		end
	}
	if mci_file.i.1 == 1 : mci_chk_stop i : if stat : mci_play i
	return

/**
 * mymci �̉��y�S�Ă��������[�v�Đ���������A�������[�v�Đ�����
 */
#deffunc mci_chk_infinity_all
	repeat max_mci_file
		if mci_file.cnt : mci_chk_infinity cnt
	loop
	return


/**
 * mymci �̊J��
 */
#deffunc mci_close onexit
	mci_destroy_all
	return

#global