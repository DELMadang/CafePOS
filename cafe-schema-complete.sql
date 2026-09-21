-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS cafe_pos COMMENT '카페 POS 시스템을 위한 데이터베이스';
USE cafe_pos;

-- 카테고리 테이블 (상품 유형 분류)
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '카테고리 고유 식별자',
    name VARCHAR(50) NOT NULL COMMENT '카테고리 이름(음료, 디저트, 굿즈 등)',
    description VARCHAR(255) COMMENT '카테고리 설명',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '카테고리 생성 일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '카테고리 정보 최종 수정 일시'
) COMMENT '상품 카테고리 정보 테이블';

-- 상품 테이블 (모든 판매 상품 정보)
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '상품 고유 식별자',
    category_id INT NOT NULL COMMENT '카테고리 ID (외래키)',
    name VARCHAR(100) NOT NULL COMMENT '상품 이름',
    description TEXT COMMENT '상품 상세 설명',
    price DECIMAL(10, 2) NOT NULL COMMENT '상품 판매 가격',
    cost DECIMAL(10, 2) COMMENT '상품 원가',
    barcode VARCHAR(50) COMMENT '바코드 정보',
    is_active BOOLEAN DEFAULT TRUE COMMENT '판매 여부 (TRUE: 판매중, FALSE: 판매중지)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '상품 등록 일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '상품 정보 최종 수정 일시',
    FOREIGN KEY (category_id) REFERENCES categories(category_id) COMMENT '카테고리와의 관계'
) COMMENT '판매 상품 정보 테이블';

-- 음료 세부 정보 테이블
CREATE TABLE beverage_details (
    beverage_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '음료 세부정보 고유 식별자',
    product_id INT NOT NULL COMMENT '연결된 상품 ID (외래키)',
    beverage_type ENUM('커피', '티', '에이드&주스', '스무디&프라페', '디카페인', '기타') NOT NULL COMMENT '음료 유형',
    is_hot BOOLEAN DEFAULT TRUE COMMENT 'HOT 제공 여부',
    is_cold BOOLEAN DEFAULT TRUE COMMENT 'ICE 제공 여부',
    caffeine_content DECIMAL(6, 2) COMMENT '카페인 함량(mg)',
    calories DECIMAL(6, 2) COMMENT '칼로리',
    detailed_description TEXT COMMENT '음료 상세 설명(맛, 특징, 원산지 등)',
    brewing_method VARCHAR(100) COMMENT '추출 방식(핸드드립, 에스프레소 등)',
    recommended_pairing TEXT COMMENT '추천 페어링(디저트, 시간대 등)',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE COMMENT '상품과의 관계(상품 삭제시 함께 삭제)'
) COMMENT '음료 상품의 세부 정보 테이블';

-- 디저트 세부 정보 테이블
CREATE TABLE dessert_details (
    dessert_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '디저트 세부정보 고유 식별자',
    product_id INT NOT NULL COMMENT '연결된 상품 ID (외래키)',
    dessert_type VARCHAR(50) COMMENT '디저트 종류(케이크, 쿠키 등)',
    contains_nuts BOOLEAN DEFAULT FALSE COMMENT '견과류 포함 여부',
    contains_dairy BOOLEAN DEFAULT FALSE COMMENT '유제품 포함 여부',
    contains_gluten BOOLEAN DEFAULT FALSE COMMENT '글루텐 포함 여부',
    is_vegan BOOLEAN DEFAULT FALSE COMMENT '비건 여부',
    detailed_description TEXT COMMENT '디저트 상세 설명(맛, 특징, 식감 등)',
    ingredients_summary TEXT COMMENT '주요 재료 요약',
    chef_recommendations TEXT COMMENT '셰프 추천 사항',
    serving_suggestions TEXT COMMENT '제공 방법 제안(온도, 음료 페어링 등)',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE COMMENT '상품과의 관계(상품 삭제시 함께 삭제)'
) COMMENT '디저트 상품의 세부 정보 테이블';

-- 굿즈 세부 정보 테이블
CREATE TABLE goods_details (
    goods_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '굿즈 세부정보 고유 식별자',
    product_id INT NOT NULL COMMENT '연결된 상품 ID (외래키)',
    goods_type VARCHAR(50) COMMENT '굿즈 종류(머그컵, 텀블러 등)',
    stock_quantity INT DEFAULT 0 COMMENT '재고 수량',
    manufacturer VARCHAR(100) COMMENT '제조사',
    detailed_description TEXT COMMENT '굿즈 상세 설명(특징, 디자인, 용도 등)',
    material VARCHAR(100) COMMENT '주요 재질',
    dimensions VARCHAR(100) COMMENT '크기 정보(용량, 치수 등)',
    care_instructions TEXT COMMENT '관리 방법 안내',
    is_limited_edition BOOLEAN DEFAULT FALSE COMMENT '한정판 여부',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE COMMENT '상품과의 관계(상품 삭제시 함께 삭제)'
) COMMENT '굿즈 상품의 세부 정보 테이블';

-- 이미지 용도 테이블
CREATE TABLE image_types (
    image_type_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '이미지 용도 고유 식별자',
    type_name VARCHAR(50) NOT NULL UNIQUE COMMENT '이미지 용도 이름',
    description VARCHAR(255) COMMENT '이미지 용도 설명',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '생성 일시'
) COMMENT '이미지 용도 분류 테이블';

-- 초기 이미지 용도 데이터 삽입
INSERT INTO image_types (type_name, description) VALUES 
('메인이미지', '상품 목록 및 메인 표시용 이미지'),
('상세이미지', '상품 상세 정보에 표시되는 이미지'),
('썸네일', '작은 크기의 미리보기 이미지'),
('배너이미지', '프로모션 배너에 사용되는 이미지'),
('SNS이미지', '소셜 미디어 공유용 이미지');

-- 제품 이미지 테이블
CREATE TABLE product_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '이미지 고유 식별자',
    product_id INT NOT NULL COMMENT '상품 ID (외래키)',
    image_type_id INT NOT NULL COMMENT '이미지 용도 ID (외래키)',
    file_name VARCHAR(255) NOT NULL COMMENT '이미지 파일명',
    file_path VARCHAR(255) NOT NULL COMMENT '이미지 파일 경로',
    file_size INT COMMENT '이미지 파일 크기(KB)',
    width INT COMMENT '이미지 너비(픽셀)',
    height INT COMMENT '이미지 높이(픽셀)',
    alt_text VARCHAR(255) COMMENT '대체 텍스트(접근성)',
    display_order INT DEFAULT 0 COMMENT '표시 순서',
    is_active BOOLEAN DEFAULT TRUE COMMENT '활성화 여부',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정 일시',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE COMMENT '상품과의 관계(상품 삭제시 함께 삭제)',
    FOREIGN KEY (image_type_id) REFERENCES image_types(image_type_id) COMMENT '이미지 용도와의 관계'
) COMMENT '상품 이미지 정보 테이블';

-- 옵션 카테고리 테이블
CREATE TABLE option_categories (
    option_category_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '옵션 카테고리 고유 식별자',
    name VARCHAR(50) NOT NULL COMMENT '옵션 카테고리 이름(사이즈, 시럽, 우유, 샷 등)',
    description VARCHAR(255) COMMENT '옵션 카테고리 설명',
    max_selections INT DEFAULT 1 COMMENT '최대 선택 가능 개수 (1:단일선택, N:다중선택)',
    display_order INT DEFAULT 0 COMMENT '화면 표시 순서',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '옵션 카테고리 생성 일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '옵션 카테고리 수정 일시'
) COMMENT '옵션 분류 테이블';

-- 초기 옵션 카테고리 데이터 삽입
INSERT INTO option_categories (name, description, max_selections, display_order) VALUES 
('사이즈', '음료 크기 선택', 1, 1),
('시럽', '시럽 선택', 3, 2),
('우유', '우유 종류 선택', 1, 3),
('샷', '에스프레소 샷 추가', 5, 4),
('얼음량', '얼음 양 선택', 1, 5),
('온도', '음료 온도 선택', 1, 6),
('휘핑', '휘핑크림 옵션', 1, 7),
('토핑', '토핑 추가', 3, 8);

-- 옵션 테이블
CREATE TABLE options (
    option_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '옵션 고유 식별자',
    option_category_id INT NOT NULL COMMENT '연결된 옵션 카테고리 ID (외래키)',
    name VARCHAR(50) NOT NULL COMMENT '옵션 이름(Small, 바닐라 시럽 등)',
    price_adjustment DECIMAL(10, 2) DEFAULT 0.00 COMMENT '가격 조정값(추가 비용)',
    inventory_impact BOOLEAN DEFAULT FALSE COMMENT '재고에 영향을 주는지 여부',
    display_order INT DEFAULT 0 COMMENT '화면 표시 순서',
    is_default BOOLEAN DEFAULT FALSE COMMENT '기본 선택 옵션 여부',
    is_active BOOLEAN DEFAULT TRUE COMMENT '사용 여부',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '옵션 생성 일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '옵션 수정 일시',
    FOREIGN KEY (option_category_id) REFERENCES option_categories(option_category_id) COMMENT '옵션 카테고리와의 관계'
) COMMENT '상품 옵션 항목 테이블';

-- 초기 옵션 데이터 삽입
INSERT INTO options (option_category_id, name, price_adjustment, display_order, is_default) VALUES 
-- 사이즈 옵션 (카테고리 ID: 1)
(1, 'Small', 0.00, 1, TRUE),
(1, 'Medium', 500.00, 2, FALSE),
(1, 'Large', 1000.00, 3, FALSE),

-- 시럽 옵션 (카테고리 ID: 2)
(2, '바닐라 시럽', 500.00, 1, FALSE),
(2, '헤이즐넛 시럽', 500.00, 2, FALSE),
(2, '카라멜 시럽', 500.00, 3, FALSE),
(2, '초콜릿 시럽', 500.00, 4, FALSE),

-- 우유 옵션 (카테고리 ID: 3)
(3, '일반 우유', 0.00, 1, TRUE),
(3, '저지방 우유', 300.00, 2, FALSE),
(3, '두유', 500.00, 3, FALSE),
(3, '오트 우유', 500.00, 4, FALSE),
(3, '아몬드 우유', 500.00, 5, FALSE),

-- 샷 옵션 (카테고리 ID: 4)
(4, '샷 추가', 500.00, 1, FALSE),

-- 얼음량 옵션 (카테고리 ID: 5)
(5, '적게', 0.00, 1, FALSE),
(5, '보통', 0.00, 2, TRUE),
(5, '많이', 0.00, 3, FALSE),

-- 온도 옵션 (카테고리 ID: 6)
(6, 'HOT', 0.00, 1, TRUE),
(6, 'ICED', 500.00, 2, FALSE),

-- 휘핑 옵션 (카테고리 ID: 7)
(7, '휘핑 없음', 0.00, 1, TRUE),
(7, '휘핑 추가', 500.00, 2, FALSE),
(7, '휘핑 많이', 700.00, 3, FALSE),

-- 토핑 옵션 (카테고리 ID: 8)
(8, '시나몬 파우더', 300.00, 1, FALSE),
(8, '초코칩', 500.00, 2, FALSE),
(8, '아몬드 슬라이스', 700.00, 3, FALSE),
(8, '코코넛 칩', 500.00, 4, FALSE);

-- 상품-옵션 매핑 테이블
CREATE TABLE product_options (
    product_id INT NOT NULL COMMENT '상품 ID (외래키)',
    option_category_id INT NOT NULL COMMENT '옵션 카테고리 ID (외래키)',
    is_required BOOLEAN DEFAULT FALSE COMMENT '필수 옵션 여부',
    min_selections INT DEFAULT 0 COMMENT '최소 선택 개수',
    max_selections INT DEFAULT 1 COMMENT '최대 선택 개수',
    display_order INT DEFAULT 0 COMMENT '화면 표시 순서',
    PRIMARY KEY (product_id, option_category_id) COMMENT '복합 기본키',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE COMMENT '상품과의 관계(상품 삭제시 함께 삭제)',
    FOREIGN KEY (option_category_id) REFERENCES option_categories(option_category_id) COMMENT '옵션 카테고리와의 관계'
) COMMENT '상품별 적용 가능한 옵션 카테고리 매핑 테이블';

-- 특정 상품에 대한 옵션 제한 테이블 (특정 상품에 특정 옵션을 제외/포함)
CREATE TABLE product_option_exclusions (
    product_id INT NOT NULL COMMENT '상품 ID (외래키)',
    option_id INT NOT NULL COMMENT '옵션 ID (외래키)',
    is_excluded BOOLEAN DEFAULT TRUE COMMENT 'TRUE: 옵션 제외, FALSE: 옵션만 포함',
    PRIMARY KEY (product_id, option_id) COMMENT '복합 기본키',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE COMMENT '상품과의 관계(상품 삭제시 함께 삭제)',
    FOREIGN KEY (option_id) REFERENCES options(option_id) COMMENT '옵션과의 관계'
) COMMENT '상품별 특정 옵션 제외/포함 설정 테이블';

-- 옵션 조합 제한 테이블 (특정 옵션 선택시 다른 옵션 제한)
CREATE TABLE option_combination_rules (
    rule_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '규칙 고유 식별자',
    product_id INT NOT NULL COMMENT '상품 ID (외래키)',
    if_option_id INT NOT NULL COMMENT '조건 옵션 ID (외래키)',
    then_option_id INT NOT NULL COMMENT '결과 옵션 ID (외래키)',
    rule_type ENUM('REQUIRE', 'EXCLUDE') NOT NULL COMMENT '규칙 유형(REQUIRE: 필수포함, EXCLUDE: 제외)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '규칙 생성 일시',
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE COMMENT '상품과의 관계(상품 삭제시 함께 삭제)',
    FOREIGN KEY (if_option_id) REFERENCES options(option_id) COMMENT '조건 옵션과의 관계',
    FOREIGN KEY (then_option_id) REFERENCES options(option_id) COMMENT '결과 옵션과의 관계'
) COMMENT '옵션 조합 규칙 테이블 (예: A옵션 선택시 B옵션 필수 또는 불가)';

-- 사용자 권한 테이블
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '권한 고유 식별자',
    role_name VARCHAR(50) NOT NULL UNIQUE COMMENT '권한 이름',
    description VARCHAR(255) COMMENT '권한 설명'
) COMMENT '사용자 권한 정보 테이블';

-- 초기 권한 데이터 삽입
INSERT INTO roles (role_name, description) VALUES 
('관리자', '시스템 관리자 권한'),
('매니저', '매장 관리자 권한'),
('바리스타', '일반 직원 권한'),
('파트타임', '아르바이트 직원 권한');

-- 직원 테이블
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '직원 고유 식별자',
    name VARCHAR(100) NOT NULL COMMENT '직원 이름',
    contact VARCHAR(20) COMMENT '연락처',
    role_id INT NOT NULL COMMENT '직원 권한 ID (외래키)',
    login_id VARCHAR(50) NOT NULL UNIQUE COMMENT '로그인 ID',
    password VARCHAR(255) NOT NULL COMMENT '로그인 비밀번호(암호화)',
    is_active BOOLEAN DEFAULT TRUE COMMENT '재직 여부',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '계정 생성 일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 최종 수정 일시',
    FOREIGN KEY (role_id) REFERENCES roles(role_id) COMMENT '권한과의 관계'
) COMMENT '직원 정보 테이블';

-- 회원 등급 테이블
CREATE TABLE membership_levels (
    level_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '등급 고유 식별자',
    level_name VARCHAR(50) NOT NULL COMMENT '등급 이름',
    min_points INT NOT NULL COMMENT '최소 포인트 기준',
    discount_rate DECIMAL(5, 2) NOT NULL COMMENT '할인율(%)',
    description VARCHAR(255) COMMENT '등급 설명'
) COMMENT '회원 등급 정보 테이블';

-- 초기 회원 등급 데이터 삽입
INSERT INTO membership_levels (level_name, min_points, discount_rate, description) VALUES 
('일반', 0, 0, '기본 회원 등급'),
('실버', 5000, 3, '실버 회원 등급'),
('골드', 10000, 5, '골드 회원 등급'),
('플래티넘', 30000, 10, '플래티넘 회원 등급');

-- 회원 테이블
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '회원 고유 식별자',
    name VARCHAR(100) NOT NULL COMMENT '회원 이름',
    phone VARCHAR(20) COMMENT '연락처',
    email VARCHAR(100) COMMENT '이메일',
    birth_date DATE COMMENT '생년월일',
    membership_points INT DEFAULT 0 COMMENT '적립 포인트',
    level_id INT DEFAULT 1 COMMENT '회원 등급 ID (외래키)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '회원 가입 일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 최종 수정 일시',
    last_visit TIMESTAMP COMMENT '최근 방문 일시',
    FOREIGN KEY (level_id) REFERENCES membership_levels(level_id) COMMENT '회원 등급과의 관계'
) COMMENT '회원 정보 테이블';

-- 결제 방법 테이블
CREATE TABLE payment_methods (
    payment_method_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '결제 방법 고유 식별자',
    method_name VARCHAR(50) NOT NULL UNIQUE COMMENT '결제 방법 이름',
    description VARCHAR(255) COMMENT '결제 방법 설명',
    is_active BOOLEAN DEFAULT TRUE COMMENT '사용 여부'
) COMMENT '결제 방법 정보 테이블';

-- 초기 결제 방법 데이터 삽입
INSERT INTO payment_methods (method_name, description) VALUES 
('현금', '현금 결제'),
('신용카드', '신용카드 결제'),
('체크카드', '체크카드 결제'),
('모바일페이', '모바일 간편결제'),
('포인트', '적립 포인트 결제');

-- 주문 상태 테이블
CREATE TABLE order_statuses (
    status_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '주문 상태 고유 식별자',
    status_name VARCHAR(50) NOT NULL UNIQUE COMMENT '주문 상태 이름',
    description VARCHAR(255) COMMENT '주문 상태 설명'
) COMMENT '주문 상태 정보 테이블';

-- 초기 주문 상태 데이터 삽입
INSERT INTO order_statuses (status_name, description) VALUES 
('접수됨', '주문이 접수되었습니다'),
('준비중', '주문이 준비 중입니다'),
('완료', '주문이 완료되었습니다'),
('픽업대기', '픽업 대기 중입니다'),
('픽업완료', '픽업이 완료되었습니다'),
('취소', '주문이 취소되었습니다');

-- 주문 테이블
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '주문 고유 식별자',
    customer_id INT COMMENT '회원 ID (외래키), NULL인 경우 비회원',
    employee_id INT COMMENT '주문 처리 직원 ID (외래키)',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '주문 일시',
    total_amount DECIMAL(10, 2) NOT NULL COMMENT '주문 총액',
    payment_method_id INT NOT NULL COMMENT '결제 방법 ID (외래키)',
    status_id INT NOT NULL DEFAULT 1 COMMENT '주문 상태 ID (외래키)',
    discount_amount DECIMAL(10, 2) DEFAULT 0.00 COMMENT '할인 금액',
    points_used INT DEFAULT 0 COMMENT '사용한 포인트',
    points_earned INT DEFAULT 0 COMMENT '적립된 포인트',
    notes TEXT COMMENT '주문 특이사항',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) COMMENT '회원과의 관계',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) COMMENT '직원과의 관계',
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id) COMMENT '결제 방법과의 관계',
    FOREIGN KEY (status_id) REFERENCES order_statuses(status_id) COMMENT '주문 상태와의 관계'
) COMMENT '주문 정보 테이블';

-- 주문 항목 테이블
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '주문 항목 고유 식별자',
    order_id INT NOT NULL COMMENT '주문 ID (외래키)',
    product_id INT NOT NULL COMMENT '상품 ID (외래키)',
    quantity INT NOT NULL DEFAULT 1 COMMENT '주문 수량',
    unit_price DECIMAL(10, 2) NOT NULL COMMENT '주문 당시 개당 가격',
    item_total DECIMAL(10, 2) NOT NULL COMMENT '항목 총액 (단가 × 수량)',
    notes TEXT COMMENT '항목 특이사항',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) COMMENT '주문과의 관계',
    FOREIGN KEY (product_id) REFERENCES products(product_id) COMMENT '상품과의 관계'
) COMMENT '주문별 상품 항목 테이블';

-- 주문 항목 옵션 테이블
CREATE TABLE order_item_options (
    order_item_option_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '주문 항목 옵션 고유 식별자',
    order_item_id INT NOT NULL COMMENT '주문 항목 ID (외래키)',
    option_id INT NOT NULL COMMENT '옵션 ID (외래키)',
    option_quantity INT DEFAULT 1 COMMENT '옵션 수량 (샷 2개 추가 등)',
    price_adjustment DECIMAL(10, 2) NOT NULL COMMENT '옵션 추가 비용',
    notes VARCHAR(255) COMMENT '옵션 관련 특이사항',
    UNIQUE KEY (order_item_id, option_id) COMMENT '동일 주문 항목에 동일 옵션 중복 방지',
    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id) ON DELETE CASCADE COMMENT '주문 항목과의 관계(주문 항목 삭제시 함께 삭제)',
    FOREIGN KEY (option_id) REFERENCES options(option_id) COMMENT '옵션과의 관계'
) COMMENT '주문 항목별 적용된 옵션 테이블';

-- 측정 단위 테이블
CREATE TABLE units (
    unit_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '단위 고유 식별자',
    unit_name VARCHAR(20) NOT NULL UNIQUE COMMENT '단위 이름',
    unit_symbol VARCHAR(10) COMMENT '단위 기호'
) COMMENT '측정 단위 테이블';

-- 초기 측정 단위 데이터 삽입
INSERT INTO units (unit_name, unit_symbol) VALUES 
('그램', 'g'),
('킬로그램', 'kg'),
('밀리리터', 'ml'),
('리터', 'L'),
('개', 'ea'),
('팩', 'pack'),
('병', 'bottle');

-- 재고 테이블
CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '재고 항목 고유 식별자',
    item_name VARCHAR(100) NOT NULL COMMENT '재고 항목 이름',
    current_quantity DECIMAL(10, 2) NOT NULL COMMENT '현재 재고량',
    unit_id INT NOT NULL COMMENT '단위 ID (외래키)',
    reorder_level DECIMAL(10, 2) COMMENT '재주문 기준점',
    cost_per_unit DECIMAL(10, 2) COMMENT '단위당 비용',
    last_restock_date TIMESTAMP COMMENT '최근 입고 일시',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '재고 항목 생성 일시',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '정보 최종 수정 일시',
    FOREIGN KEY (unit_id) REFERENCES units(unit_id) COMMENT '단위와의 관계'
) COMMENT '재고 관리 테이블';

-- 거래 유형 테이블
CREATE TABLE transaction_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '거래 유형 고유 식별자',
    type_name VARCHAR(50) NOT NULL UNIQUE COMMENT '거래 유형 이름',
    description VARCHAR(255) COMMENT '거래 유형 설