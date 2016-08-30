function roll(n) {
    run_command('r' + n);
}

function action(comm) {
    run_command(comm);
}

function run_command(command) {
    //alert('run_command');
    $.get("/game/go", {
            comm: command
        },
        function(data) {
            UpdatePage(data);
        });
}

function UpdatePage(data) {
    $.each(data.Map, function(i, item) {
        var rent = '';
        var hh=0;
        if (item.text !==null) {
            cell_info = item.text.split(' ');
            rent=cell_info[0];
            if (cell_info.length>1){
                hh = cell_info[1].replace('H', '');
                hh = parseInt(hh);
            }
        }

        $('#map_c' + item.id).attr("data-owner",item.own)
        .attr("data-grcount",item.grcount)
        .attr("data-rent",item.text)
        .attr("data-houses",item.hh)
        .attr("title",cells[i].title + ', рента:'+rent+(hh>0?' домов:'+hh :''));
        //.html(cells[i].title)
        //.html(item.text)
        $('#map_c' + item.id + ' span:first-child').css('backgroundColor', pcolors[item.own]);
        if (item.text!='') {$('#map_c' + item.id + ' span.price').html('$'+item.text);}

    });

    $("#player_buttons").html(data.PlayerButton);
    $("#logs").html(data.GameLog);
    $("#plinfo").html(data.PlayersInfo);
    $("#timer").html(data.Timer);

    $('div.runway').html('');

    $.each(data.PlayersPos, function(i, item) {
        //$('#map_c' + item.pos).append(pimages[item.id]);
        last = pl_pos[item.id]

        forward = last < item.pos || (last - item.pos > 25);
        steps = forward ? item.pos - last : last - item.pos;
        steps = steps < 0 ? steps + 40 : steps;

        for (var i = 0; i <= steps; i++) {
            curr = forward ? (last + i) % 40 : last - i;
            mcell = $('#map_c' + curr+' .runway');
            mcell.append(pimages[item.id]);
            
        }
        pl_pos[item.id] = item.pos;
    });
}

function upd_player_cells() {
    $.get("/game/player_cells",
        function(data) {
            $("#divPlayerCells").html(data.player_cells);
        });
}
function show_game_logs() {
    $.get("/game/show_game_logs",
        function(data) {
            $("#log").html(data.xlogs);
        });
}
function chSpeedUpdate() {
    var ch = $('#speedUpd').is(':checked');
    if (ch) {
        clearInterval(updater);
        updater = setInterval('loadPageData()', 2000);
    } else {
        clearInterval(updater);
        updater = setInterval('loadPageData()', 1000);
    }
}

function sendMessage() {
    $.post("/Ajax/SendGameMessage", {
            mes: $("#chatMessage").val()
        },
        function(data) {
            //$("#divChat").html(data);
        }
    );
    $("#chatMessage").val("");
}