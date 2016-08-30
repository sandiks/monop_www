function player_cells_action(meth,data) {
    $.get("/game/"+meth,
        { str: data },
        function(data) {
            //$("#divPlayerCells").html(data.player_cells);
        });
}
function parse_data(pid, s){
   cid = parseInt(s) || 0;
   return cid ==0?state(): 'p'+pid+'-'+cid;
}
function Mortgage(pid, s) {
   player_cells_action("mortgage",parse_data(pid, s));
}
function Unmortgage(pid, s) {
   player_cells_action("unmortgage",parse_data(pid, s));
}
function Build(pid, s) {
   player_cells_action("build_houses",parse_data(pid, s));
}

function Sell(pid, s) {
   player_cells_action("sell_houses",parse_data(pid, s));
}

function state() {
    var str = "p0";
    $("input[name='0_ids[]']:checked").each(function(i) {
        str += "-" + $(this).val();
    });


    str += ";p1";
    $("input[name='1_ids[]']:checked").each(function(i) {
        str += "-" + $(this).val();
    });


    str += ";p2";
    $("input[name='2_ids[]']:checked").each(function(i) {
        str += "-" + $(this).val();
    });
    
    str += ";p3";
    $("input[name='3_ids[]']:checked").each(function(i) {
        str += "-" + $(this).val();
    });
    return str;
}

function Trade() {

    $.get("/game/trade",
        { str: trade_data() },
        function(data) {
            $("#player_cells_result").html(data.result);
    });

}

function trade_data() {

    var str = "p0";

    $("input[name='0_ids[]']:checked").each(function(i) {
        str += "-" + $(this).val();
    });

    //str += "-m" + $("#0_m").val();

    str += ";p1";

    $("input[name='1_ids[]']:checked").each(function(i) {
        str += "-" + $(this).val();
    });
    //str += "-m" + $("#1_m").val();

    str += ";p2";

    $("input[name='2_ids[]']:checked").each(function(i) {
        str += "-" + $(this).val();
    });
    //str += "-m" + $("#2_m").val();

    str += ";p3";

    $("input[name='3_ids[]']:checked").each(function(i) {
        str += "-" + $(this).val();
    });
    //str += "-m" + $("#3_m").val();

    return str;
}
