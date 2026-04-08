$names = @('Nguyễn Văn Anh','Trần Thị Hương','Phạm Huỳnh Minh Tuấn','Hoàng Nhật Hà','Lê Thu Oanh','Marcus Chen','Đỗ Thanh Hồng','Nguyễn Minh Tiến','Linh Phương','Trần Vinh Phúc','Vũ Hương Mai','Sarah Thompson','Ngô Minh Khang','Jennifer Kim','David Kim','Alex Brown','Maria Garcia','Giovanni','Chen Liu','Patrick','Michael Wilson')

$categories = @{
    'cafephanxet.csv' = @(
        'Đã ghé 10+ lần. Cà phê ngon, không đắng hay nhạt. Lớp foam cappuccino mịn tuyệt. Không gian yên, wifi tốt. Nhân viên nhớ tên. Hôm chờ 15p vì bận.',
        'Lần đầu tới hơi ngại nhưng thiết kế đẹp, tường hình phố Hà Nội xưa. Cà phê mùi chua lạ lẫm. Sẽ quay lại.',
        'Giá hơi cao nhưng xứng. Pastry ngon, croissant nổi tiếng. Hôm phục vụ chậm, chờ 20p.',
        'Chủ quán cựu barista Australia. Flat White hương vị tuyệt, mịn như lụa.',
        'Cà phê yên bình nhưng đắt! 100k/tách. Quán bận hết chỗ. Nhân viên hơi vô ý.',
        'Amazing! Tìm by accident. Owner friendly. Egg coffee silky sweet. Wifi changed inconvenient.',
        'Quán nhỏ xinh, décor đẹp, bàn ngoài sân. Cà phê sướng. Nhân viên cười. Chỉ tiếc bánh hết.',
        'Coffee enthusiast. Một trong tốt nhất. Hạt rang riêng, mùi thơm sáng. Chủ giỏi.',
        'Ấn tượng cách phục vụ. Nhân viên kiểm tra lạnh, thay cốc. Cà phê khác nhưng ngon.',
        'Quán hay khách nước ngoài. Hôm chứng kiến giải thích pha cà phê cho Pháp. Lâu lâu vui.',
        'Ghé trốn ồn. Yên tĩnh. Cà phê mát, mùi thơm. Máy foam Italy. Tuyệt!'
    );
    'chophanxet.csv' = @(
        'Ghé 5 năm. Sợ bẩn nhưng sạch, không hôi. Bà vui, lúc chào. Chọn tươi, bó gọn. Giá công bằng.',
        'Chợ sạch gọn, tổ chức tốt. Mỗi khu riêng dễ mua. Xếp hàng lâu. Cá mùi nặng.',
        'Hay mua đặc sản. Người khác vùng mang tươi ngon. Bí tươi, dưa xanh ngon. Nhân viên tâm.',
        'Thường xuyên. Rau cải luôn tươi. Súp lơ xanh tuyệt. Tiểu thương tốt.',
        'Chợ sạch, hàng đa dạng. Khu riêng gọn. Giá tốt, không chặt.',
        'Very clean! Vegetables fresh, prices good. Staff friendly. Only bit far.',
        'Ghé mua trái cây. Xoài, chuối rẻ hơn siêu thị. Bà hay trêu. Hôm bán không đủ.',
        'Sạch không lẫn. Hàng mới lạ. Nhân viên tốt. Vị trí tiện.',
        'Thường mua cà chua, dưa hấu. Tươi lúc nào. Giá ổn.'
    );
    'chuaphanxet.csv' = @(
        'Nhật, lần đầu. Yên bình bước vào. Kiến trúc gỗ mộc, mục sư áo nâu. Tâm giải thích. Quên sầu muộn.',
        'Lần 2 với mẹ. Thanh tịnh, yên tĩnh. Mục sư hỏi, dạy cầu. Tôn trọng. Tiếc mục sư bệnh.',
        'Giáo phụ thân thiện. Dẫn tham quan, vườn yên, cây to. Hôm mục sư ít.',
        'Chùa cổ, 100 năm. Yên tĩnh, linh thiêng. Mục sư tư vấn. Cầu sâu.',
        'Lần đầu. Yên bình. Thiêng liêng. Mục sư hiền, vui. Quay lại.',
        'Beautiful! Peaceful. Monks kind, explained. Spiritual connection. Meditation session.',
        'Ghé mệt mỏi. Yên tĩnh làm sạch tâm. Mục sư dạy thiền. Bình an.',
        'Rộng, thoáng. Thiên nhiên đẹp. Mục sư tươi. Thường ghé.',
        'Linh thiêng, tâm linh mạnh. Vườn xanh. Mục sư thực thiền. Yên bình.'
    );
    'congvienphanxet.csv' = @(
        'Công viên đẹp, cảnh xanh. Gia đình ghé cuối tuần. Sân chơi bé tốt. Không khí thoáng. Sĩ số đông.',
        'Lần thứ 3 ghé. Yên tĩnh, xanh mát. Đi bộ vòng 1h ok. Ghế dài ngồi. Cối bảo vệ tươi.',
        'May mắn hôm thời tiết đẹp. Cảnh tự nhiên yên bình. Đi bộ sáng sục. Không gian thoáng.',
        'Gia đình hay tới. Sân chơi an toàn, bé vui. Cây cỏ xanh tươi. May hôm không ô nhiễm.',
        'Tuyệt vời cho bạn bè. Không khí sạch lành. Con đường đẹp. Ghế dài thoải.',
        'Great park! Peaceful, green, safe for kids. Facilities good. Weather bit hot.'
    );
    'karaokephanxet.csv' = @(
        'Âm thanh tốt, phòng sạch. Bài hát mới, cập nhật. Nhân viên nhanh. Vui vẻ bạn. Xứng tiền.',
        'Lần đầu rất hài lòng. Hệ thống hiện đại. Hát vui. Đồ ăn nhanh. Giá ổn.',
        'Quán này favorite nhóm. Âm thanh hay, không hú. Bài hát luôn mới. Phòng thoáng.',
        'Quán tôi thường tới. Ánh sáng phù hợp. Máy lạnh tốt. Nhân viên vui vẻ. Sẽ quay lại.',
        'Ồn ào nhưng đó tính chất. Chất lượng âm tốt hơn nơi khác. Hát quên thời gian.',
        'Nice karaoke! Machines work well. Staff helpful. Only bit crowded weekend.'
    );
    'khachsanphanxet.csv' = @(
        'Ở được 3 đêm, rất hài lòng. Phòng sạch, nội thất hiện đại. Phục vụ 24/7. Gần du lịch. Bữa sáng tuyệt.',
        'Vượt kỳ vọng. Sạch sẽ, giường êm. Nhân viên nhớ yêu cầu. An toàn gia đình. Bảo vệ 24/7.',
        'Lần 2 vì lần đầu tuyệt. Phòng ráp sạch. Tầm nhìn đẹp. Mini bar, nước nóng 24/7.',
        'Khách sạn nhỏ nhưng sạch. Phục vụ chu đáo. Vị trí trung tâm. Giá hợp lý.',
        'Nhân viên chào hỏi thân thiện. Không khí thoải. Sạch sẽ yên tâm. Lần 2 sẽ ở lại.',
        'Good hotel! Clean rooms, friendly staff. Location convenient. Reasonable price. Will return.'
    );
    'nhathophanxet.csv' = @(
        'Kiến trúc tuyệt đẹp, mái vòm cao. Không gian linh thiêng. Cộng đoàn ấm áp. Giáo phụ tế nhị.',
        'Lần đầu tôi rất yêu. Không gian thanh tịnh. Dự lễ cảm động. Mục sư tâm linh.',
        'Ngôi nhà thờ cổ. Kiến trúc từ thế kỷ 19. Ánh sáng tự nhiên đẹp. Nơi tu tập tuyệt vời.',
        'Nơi thờ phụng linh thiêng. Có hoạt động từ thiện. Giáo dạy tốt. Bình yên.',
        'Thanh bình nơi cầu nguyện. Cộng đoàn hỗ trợ nhau. Mục sư kiên nhân. Cảm tâm linh.'
    );
    'quanatphanxet.csv' = @(
        'Quán này favorite gia đình. Cà phê tương tự nhưng cơm tấm ngon. Canh chua tuyệt vời. Giá vừa vặn.',
        'Lần đầu nhanh hài lòng. Hương vị truyền thống, không khô. Bơi thoáng, chỗ ngồi thoải.',
        'Ghé 10+ lần. Đồ ăn luôn ngon, tươi mới. Chủ quán lựa chọn kỹ. Phục vụ tận tình.',
        'Quán nhỏ nhưng mỹ vị. Cơm tấm, canh chua, nem rán tuyệt. Hơi bận nhưng nhanh.',
        'Đồ ăn đặc biệt, vị không khó tìm. Nhân viên nhớ yêu thích. Sạch sẽ an toàn.'
    );
    'thuexephanxet.csv' = @(
        'Xe sạch, an toàn. Tài xế lịch sự, kinh nghiệm. Giá hợp lý. Giao xe nhanh. Chuyên nghiệp.',
        'Lần thứ 2 thuê vì tốt. Xe mới, an toàn kiểm tra. Tài xế không lạ, là hướng dẫn viên. Giá xứng.',
        'Công ty tốt nhất. Xe luôn sạch, kiểm tra định kỳ. Tài xế chuyên nghiệp, đúng giờ. Sẽ thuê lại.',
        'Chuyến du lịch dài. Tài xế kinh nghiệm, không ồn. Xe gọn, máy lạnh tốt. Gia đình hài lòng.',
        'Ghé châu Âu, thuê được xe ổn. Tài xế vui vẻ, biết nơi hay. Máy lạnh đủ. Thoải mái.'
    );
}

$times = (1..180) | ForEach-Object {(Get-Date).AddDays(-$_).ToString('dd/MM/yyyy HH:mm')}

foreach ($file in $categories.Keys) {
    $csv_lines = @('Tên người nhận xét,Đánh giá,Nội dung,Thời gian')
    
    for ($i = 0; $i -lt 100; $i++) {
        $name = $names | Get-Random
        $r = Get-Random
        if ($r -lt 0.15) {$rating = 3} elseif ($r -lt 0.45) {$rating = 4} else {$rating = 5}
        $review = $categories[$file] | Get-Random
        $time = $times | Get-Random
        $csv_lines += "$name,$rating,""$review"",$time"
    }
    
    $csv_lines | Out-File -FilePath $file -Encoding UTF8 -Force
    Write-Host "✓ $file"
}
