# Verilog_HDL
Logic design project(Baseball game)

## Rules
	게임의 규칙음 다음과 같다. 
	①게임 시작시 임의의 4자리 숫자를 출제.
	②사용자는 정답으로 추정되는 4자리의 숫자를 입력.
	③입력한 4자리 숫자 중 임의의 4자리 숫자와 값과 자리 모두 같으면 S!
		ex) 정답 : 1234 / 입력 : 9874 ⇒ 1 S
	       	    정답 : 1234 / 입력 : 9274 ⇒ 2 S
	④입력한 4자리 숫자 중 임의의 4자리 숫자중 하나와 같은 값을 가지되 자리가 다르면 B!
		ex) 정답 : 1234 / 입력 : 9473 ⇒ 2 B
	   	    정답 : 1234 / 입력 : 9214 ⇒ 2 S / 1 B
	⑤주어진 힌트를 바탕으로 숫자를 계속 추리하여 4자릿수를 모두 맞추면 (4 S이면) 성공.

## 0SEG_DEC module
	segment에 표시할 수 있도록 해주는 module 이다.
	input으로 DIGIT을 받아 output으로 segment에 넣을 수 있도록 짜주었다.

	DIGIT값을 받을때 0~15 까지 받을수 있게 16진수로 15까지의 값을 테이블로 만들어주었고,

	segment의 dot 부분을 표시하고 싶을떄 DIGIT에 20을 더해주면 dot이 표시되도록 추가 테이블을 작성 해주었다.

## DOT module
	위의 코드는 게임 결과 나타난 S와 B를 측정하여 DOT 매트릭스에 나타내는 코드이다. 
	dot_10이 10’b1000000000일 때 첫번째 열이 Enable 되고 dot_14의 데이터가 Enable 된 열에 나타난다.
	이를 이용하여 dot_10을 빠르게 순환 시켜 연속하여 켜져 있는 것처럼 보이게 한다. 
	열에 해당하는 상태를 count_10으로 놓았고 count_10을 1부터 10까지로 놓아 그 값에 맞는 열을 표시하도록 테이블을 짜주었다. 
	세그먼트를 나타내는 방식과 유사하다. 
	
	게임으로 부터 S값을 받아 S값이 4보다 작을 때 즉 아직 성공하지 못하였을때에는 S와 B의 숫자가 뜨도록 하였고, 
	성공하였을 때에는 폭죽모양의 애니매이션이 뜨도록 테이블을 짜주었다. 
	폭죽 모양의 애니매이션은 h_state라는 reg값이 1부터 15일때까지 장면을 짜주었으며, 
	약 0.5초에 한 상태씩 넘어가도록 만들어 연속적으로 움직이는 애니매이션 처럼 표시해주었다.

## times module 
	클리어 까지 시간을 측정해준다.
	input으로 clk. reset, S 값을 받고
	output으로 COUNT_1, COUNT_10, COUNT_M을 준다.
	COUNT_1 은 1초, COUNT_10은 10초, COUNT_M은 1분 단위를 나타내며 
	게임에서 주는 S값을 받아 S가 4일 때 즉 게임을 성공 했을때 

		COUNT_1 <= COUNT_1, COUNT_10 <= COUNT_10,
		COUNT_M <= COUNT_M 

	을 넣어주어 시계가 멈추도록 하여 클리어 시간을 알 수 있게 해주었다.


## random_number module
	임의의 4자리 숫자를 만들어주는 프로그램이다

	input 으로 clk,stb,enb을 받고
	output 으로 n1,n2,n3,n4를 준다.

	클럭으로 25MHz 클럭을 받고 이를 10분주하여 0.4㎲ 마다 숫자가 1씩 바꾸게 해주어 0000부터 9999까지 반복되고 
	stb을 눌렀을때 카운터를 중지하고 그 숫자를 n4,n3,n2,n1 에 저장해주는 방식이다.

	사실 엄밀히 따지자면 완전히 무작위는 아니지만, 사람이 stb을 누른다고 생각했을때 
	작위적으로 숫자를 맞추기도 불가능하고 열번 누르면 열번 다른 숫자가 나오기 떄문에 
	임의의 네자리수가 나오는 것처럼 보인다고 생각하여 이런 방식을 사용했다.

## key_in
	키패드에서 키를 입력받아 세그먼트에 나타내고 하위 module random_number로 받아온 임의의 4자릿수와 비교하여 
	S/B을 하위 module DOT를 이용하여 dot-matrix에 나타내고 시간을 측정하는 최상위 module이다. 

	random_number에서 받아온 n1,n2,n3,n4와 
	key_data로 입력한 nn1,nn2,nn3,nn4를 
	case문을 이용하여 비교하며
	nn1가 n1 값과 같을떄 s1=1
	nn1가 n2,3,4, 값과 같을떄 b1=1 로 값을 대입하여
	S = s1+s2+s3+s4,
	B = b1+b2+b3+b4, 로 계산하여 전체 S값과 B값을 알 수 있다.
	
	nn1,nn2,nn3,nn4를 dip switch로 지정해주어 바꾸고 싶은 자리를 바꿀 수 있도록 선택 해주었으며

	1초에 하나씩 check_counter가(LED로 표시) 줄어들고 
	8자리 check_counter가 0이되면 check값이 1씩 증가한다.
	check가 15즉 F가 되면 세그먼트에는 모두 FFFFFFFF가 뜨며 게임이 끝나게 된다.(8 * 15 = 120, 즉 2분)

	check 값이 15가 되지 않았을때에는 

		if(check < 15)begin
		case (SEL_SEG) 
		0 : seg_TMP <= nn1;
		1 : seg_TMP <= nn2;
		2 : seg_TMP <= nn3;
		3 : seg_TMP <= nn4;
		4 : seg_TMP <= COUNT_1;
		5 : seg_TMP <= COUNT_10;
		6 : seg_TMP <= COUNT_M+20;
		7 : seg_TMP <= check;

	다음과 같이 선언 해주어 
	0~3까지는 사용자가 키패드로 입력하는 숫자를, 
	4~6까지는 게임 시간을 ( 분에는 +20을 해주어 dot을 표시)
	7 에는 check값을 표시하도록 segment를 분배해주었다.
